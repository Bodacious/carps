require "util/process"

require "drb"

class Mutate

   include DRbUndumped

   def initialize
      @works = "WORK IT DOES NOT!"
   end

   def mutate!
      @works = "It works!"
   end

   def works?
      @works
   end

end

Given /an object to be mutated/ do
   $mut = Mutate.new
end

Given /^the process subsystem is initialized with '(.+)'$/ do |process|
   init_process process
end


When /^the \$process.ashare method is run with a computation to mutate the object$/ do
   $process.ashare $mut, lambda {|uri|
      ob = DRbObject.new_with_uri uri
      ob.mutate!
      puts "In child:"
      puts "\t" + ob.works?
   }
end

Then /^I should see 'It works' from the server side$/ do
   puts "On server side:"
   puts "\t" + $mut.works?
end

When /^the \$process.launch method is called with the name of a ruby subprogram, which I should see in another window$/ do
   $process.launch $mut, "test_extra/ipc.rb"
end