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

require "protocol/message"

require "mod/answers"
require "util/question"

# A question sent by the server, to be asked of the player.
#
# Interacts with Answers class
class Question < Message

   # Extend the protocol
   protoval :question

   # Create a question
   def initialize addr, question, delayed_crypt = nil
      super addr, delayed_crypt
      @text = question
      @type = question_type
   end

   # Parse from the void
   def Question.parse from, blob, delayed_crypt
      question, blob = find K.question, blob
      [Question.new(from, question, delayed_crypt), blob]
   end

   # Emit
   def emit
      V.question @text 
   end

   # Ask the question, store the answer in the answers object
   def ask answers
      response = question @text
      answers.answer @text, @response
   end 

end
