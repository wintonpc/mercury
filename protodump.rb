require_relative 'lib/everything'

require 'base64'

if ARGV[0]
  msg = WireSerializer.read(Base64.decode64(ARGV[0]))
  dump_message(msg)
  puts
else
  puts 'no input!'
end
