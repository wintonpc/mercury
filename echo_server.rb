require_relative 'lib/messaging'

EM.run do
  mercury = Mercury.new
  mercury.new_singleton 'echo-service' do |msg|
    puts "Got '#{msg.content}'"
    mercury.send_to(msg.sender, Ib::Echo::V1::Response.new(content: msg.content))
  end
  puts 'Listening...'
end
