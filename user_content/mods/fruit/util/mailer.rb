require "drb"

# Get a reference to the mailer object
def init_mailer
   mailer_url = ARGV.shift
   puts "Listening on " + mailer_url
   DRbObject.new nil, mailer_url
end