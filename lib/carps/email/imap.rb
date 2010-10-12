# Copyright 2010 John Morrice

# This file is part of CARPS.

# CARPS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# CARPS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with CARPS.  If not, see <http://www.gnu.org/licenses/>.


require "carps/protocol/message"

require "carps/ui/warn"

require "carps/email/string"

require "carps/util/timeout"


require "net/imap"

module CARPS

   # Administer IMAP connections
   class IMAP

      # Initialize with a hash of IMAP settings and password
      #
      # Uh, poorly documented.  See source.
      def initialize settings, password
         @port = settings["port"]
         @server = settings["server"]
         @tls = settings["tls"]
         @username = settings["user"]
         @cert = settings["certificate"]
         @verify = settings["verify"]
         @login = settings["login"]
         @cram_md5 = settings["cram_md5"]
         @password = password
      end

      # Are the settings okay?
      def ok?
         good = false
         begin
            attempt_connection
            @imap.logout
            good = true
         rescue StandardError => e
            UI::put_error e.to_s
         end
         good
      end

      # Attempt a connection
      def attempt_connection
         puts "Making IMAP connection for " + @username
         puts "Server: #{@server}, Port: #{@port}"
         CARPS::timeout 30, "IMAP connection attempt" do
            if not @tls or @password.empty?
               UI::warn "IMAP connection is insecure."
            end
            @imap = Net::IMAP.new @server, @port, @tls, @certs, @verify
            if @cram_md5
               @imap.authenticate "CRAM-MD5", @username, @password
            elsif @login
               @imap.authenticate "LOGIN", @username, @password
            else
               @imap.login @username, @password
            end
         end
         unless @imap
            raise StandardError, "No IMAP connection."
         end
      end

      # Connect to imap server
      def connect
         until false
            begin
               attempt_connection
               return
            rescue Net::IMAP::NoResponseError => e
               if e.message == "Authentication failed."
                  UI::put_error e.to_s
                  @password = UI::secret "Enter IMAP password for #{@username}"
               else
                  warn_delay
               end
            rescue
               warn_delay
            end 
         end
      end

      def delay
         30
      end

      # Return the a list of email message bodies
      #
      # If the inbox is empty, wait delay seconds before polling it again
      def read 
         # A reader
         reader = lambda do
            mails = []
            # Block 'till we get one
            while mails.empty?
               @imap.select("inbox")
               # Get all mails
               messages = @imap.search(["ALL"])
               if messages.empty?
                  sleep delay
               else
                  mails = @imap.fetch messages, "BODY[TEXT]"
                  mails = mails.map do |mail|
                     from_mail mail.attr["BODY[TEXT]"]
                  end
                  # Delete all mails
                  messages.each do |message_id|
                     @imap.store(message_id, "+FLAGS", [:Deleted])
                  end
                  @imap.expunge
               end
            end
            mails
         end
         mails = []
         until 
            begin
               mails = reader.call
            rescue
               UI::warn "Error receiving messages"
               if mails.empty?
                  connect
               end
            end
         end
         mails
      end

      protected

      # Warn that we're going to delay before trying again
      def warn_delay
         UI::warn "Could not connect to IMAP server", "Attempting to reconnect in 10 seconds."
         sleep 10
      end

   end

end
