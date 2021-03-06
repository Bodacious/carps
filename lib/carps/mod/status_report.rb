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

require "carps/protocol"

module CARPS

   # Text sent by the server to be viewed on the client.
   class StatusReport < Message

      # Extend the protocol
      protoval :status_report

      # Create a status report
      def initialize text
         @text = text
      end

      # Parse from the void
      def StatusReport.parse blob
         status, blob = find K.status_report, blob
         [StatusReport.new(status), blob]
      end

      # Emit
      def emit
         V.status_report @text
      end

      # Display the text
      def display
         puts @text
      end

   end

end
