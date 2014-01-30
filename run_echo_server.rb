$LOAD_PATH << File.absolute_path(File.join(File.dirname(__FILE__), 'lib'))

require 'eventmachine'
require 'mercury'
require 'messages'

EM.run do
  mercury = Mercury.new
  ms = mercury.new_singleton 'echo-service' do |msg|
    ms.send_to(msg.sender, Ib::Echo::V1::Response.new(content: "echo>> #{msg.content} <<echo"))
  end
end
