require File.dirname(__FILE__) + "/../../lib/carps"

gem 'cucumber'
require 'cucumber'

# This is shit and means I can't test carps properly
# Before do
#  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
#  @home_path = File.expand_path(File.join(@tmp_root, "home"))
#  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
#  FileUtils.rm_rf   @tmp_root
#  FileUtils.mkdir_p @home_path
#  ENV['HOME'] = @home_path
# end
