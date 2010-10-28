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

require "carps/util/config"

require "carps/ui/error"

require "tempfile"

module CARPS

   # Expects a field called "launch_editor"
   class Editor < SystemConfig

      def Editor.filepath
         "editor.yaml"
      end

      def initialize editor, wait_for_confirm = false
         @editor = editor
         @wait_confirm = wait_for_confirm
      end

      def parse_yaml config
         @editor = read_conf config, "launch_editor"
         @wait_confirm = read_conf config, "wait_for_confirm"
      end

      # Edit a string
      #
      # Not re-entrant
      def edit msg
         begin
            file = Tempfile.new "carp_edit"
            path = file.path
            file.write "# Lines starting with # will be ignored.\n" + msg 
            file.close
            contents = edit_file path
            if @wait_conirm
               UI::question "Press enter when you are done editing."
            end
            lines = contents.split /\n/
            lines.reject! do |line|
               line[0] == '#'
            end
            lines.join "\n"
         rescue StandardError => e
            UI::put_error e.to_s
            nil
         end
      end

      protected

      def edit_file filepath
         child = fork do
            exec @editor.gsub "%f", filepath
         end
         Object::Process.wait child

         if File.exists? filepath
            return File.read filepath
         else
            return ""
         end
      end


      # Emit as hash
      def emit
         {"launch_editor" => @editor}
      end

   end

end
