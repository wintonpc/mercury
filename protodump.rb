require_relative 'lib/messaging'

require 'base64'
require 'ap'
require 'pp'

if ARGV[0]
  msg = WireSerializer.read(Base64.decode64(ARGV[0]))
  ap WireSerializer.to_hash(msg), sort_keys: true
else
  puts 'no input!'
end
