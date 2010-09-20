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

# Types available in character sheets
#
# Subclasses should provide a method called coercion, which should return a symbol referring to a method which coerces a value into a different type (example, :to_s)
class SheetType

   def initialize optional
      @optional = optional
   end

   def verify val
      coercable = val.respond_to?(coercion)
      if val == nil
         if @optional
            return [true, nil]
         end
      elsif coercable
         if empty(val) and @optional
            return [true, nil]
         else
            [true, val.send(coercion)]
         end
      else
         [false, nil]
      end
   end

end

class SheetInt < SheetType

   def coercion
      :to_i
   end

   def empty val
      false
   end

end

class SheetText < SheetType

   def coercion
      :to_s
   end

   def empty val
      if val.class == String
         return val.empty?
      else
         return false
      end
   end

end

# Parse the sheet types from strings
class TypeParser
   def TypeParser.parse optional, type_name
      if type_name == "integer"
         return SheetInt.new optional 
      elsif type_name == "text"
         return SheetText.new optional
      end
   end
end