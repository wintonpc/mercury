$LOAD_PATH << File.absolute_path(File.join(File.dirname(__FILE__), 'lib'))

require 'eventmachine'
require 'mercury'
require 'messages'

EM.run do
  mercury = Mercury.new
  ms = mercury.new_singleton do |msg|
    puts "got response '#{msg.content}'"
  end
  ms.send_to('echo-service', Ib::Echo::V1::Request.new(sender: ms.name, content: 'hello there'))
end
