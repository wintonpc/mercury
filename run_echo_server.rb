require_relative 'lib/messaging'

EM.run do
  mercury = Mercury.new
  ms = mercury.new_singleton 'echo-service' do |msg|
    ms.send_to(msg.sender, Ib::Echo::V1::Response.new(content: msg.content))
  end
end
