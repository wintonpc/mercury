require_relative 'lib/everything'

require 'base64'
require 'ap'
require 'colorize'

if ARGV[0]
  msg = WireSerializer.read(Base64.decode64(ARGV[0]))
  puts
  puts msg.class.to_s.red
  ap WireSerializer.to_hash(msg), sort_keys: true
  puts
else
  puts 'no input!'
end
