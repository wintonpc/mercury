$LOAD_PATH << File.absolute_path(File.join(File.dirname(__FILE__), 'lib'))

require 'mercury'
require 'messages'

Mercury.request('echo-service', ->(sender){Ib::Echo::V1::Request.new(sender: sender, content: ARGV[0])}) do |response|
  puts "echoed: '#{response.content}'"
end
