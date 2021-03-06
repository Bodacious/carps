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

require "carps/service"

require "carps/mod"

require "carps/ui"

module CARPS

   # Interface for roleplaying
   class RolePlayInterface < QuitInterface

      def initialize
         super
         add_command "d", "Roll a dice with a given number of sides.", "SIDES"
         add_command "int", "An random integer between MIN and MAX.", "MIN", "MAX"
         add_command "dec", "A decimal between MIN and MAX.", "MIN", "MAX"
      end

      def d n
         i = n.to_i
         if i <= 1
            UI::put_error "A dice must have more than 1 side."
         else
            puts Dice::rint(1, i)
         end
      end

      def int min, max
         min = min.to_i
         max = max.to_i
         if min >= max
            bounds_err
         else
            puts Dice::rint(min, max)
         end
      end

      def dec min, max
         min = min.to_f
         max = max.to_f
         if min >= max
            bounds_err
         else
            puts Dice::rfloat(min, max)
         end
      end

      private

      def bounds_err
         UI::put_error "MIN must be less than MAX."
      end

   end

end
