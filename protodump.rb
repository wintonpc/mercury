$LOAD_PATH << File.absolute_path(File.join(File.dirname(__FILE__), 'lib'))

require 'base64'
require 'messages'
require 'wire_serializer'
require 'pp'

if ARGV[0]
  msg = WireSerializer.read(Base64.decode64(ARGV[0]))
  pp msg
else
  puts 'no input!'
end
