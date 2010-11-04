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

require "carps/ui"
require "carps/util"

module CARPS

   # Output an error message and quit with exit code 1
   def CARPS::fatal msg
      h = HighLine.new
      $stderr.write h.color("\nFATAL ERROR\n#{msg}\n", :error)
      puts "\a"
      exit 1
   end

   # Catch errors and print out a stack trace if they occur.
   #
   # Pass a block.
   #
   # Intented to be run at the top level (Eg by the binaries)
   def CARPS::with_crash_report
      begin
         yield
      rescue StandardError => e
         UI::put_error e.message + "\n" + e.backtrace.join("\n")
         CARPS::enter_quit         
      end
   end

end

