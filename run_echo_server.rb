$LOAD_PATH << File.absolute_path(File.join(File.dirname(__FILE__), 'lib'))

require 'eventmachine'
require 'mercury'
require 'messages'

Request = Ib::Echo::V1::Request
Response = Ib::Echo::V1::Response

EM.run do
  mercury = Mercury.new
  ms = mercury.new_singleton 'echo-service' do |msg|
    ms.send_to(msg.sender, Response.new(content: "echo>> #{msg.content} <<echo"))
  end
end
