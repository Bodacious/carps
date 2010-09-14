require "mod/dm/mod"
require "mod/dm/resource"

class TestMod < Mod
   def schema
      {"name" => "text",
       "fruit" => "text",
       "days old" => "integer"}
   end

   def update_barry status
      @reporter.update_player "barry", status
   end

end

class TestMailer

   def send addr, mail
      if mail.class == CharacterSheetRequest
         sheet = mail.fill
         sheet.from = $email
         @sheet = sheet
      end
   end

   def read klass
      if klass == Answers
         loop do
            sleep 1
         end
      elsif klass == CharacterSheet
         until @sheet
            sleep 1
         end
         sheet = @sheet
         @sheet = nil
         return sheet
      end
   end

end

Given /^a DM mod$/ do
   resource = Resource.new "test_extra/resource"
   $mailer = TestMailer.new
   $mod = TestMod.new resource, $mailer
end

$email = "barry@doodah.xxx"

When /^barry joins the mod$/ do
   $mod.add_known_player "barry", $email 
end

Then /^set barry's status conditionally$/ do
   puts "If barry is a banana, then his status shall be 'socks', otherwise 'rambo'"
   if Ch.barry.fruit == "banana"
      $mod.update_barry "socks"
   else
      $mod.update_barry "rambo"
   end
end

Then /^preview player turns$/ do
   $mod.inspect_reports
end

Then /^check barry's sheet$/ do
   received = false
   until received
      received = $mod.check_mail
      sleep 1
   end
end
