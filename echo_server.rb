require_relative 'lib/everything'

EM.run do
  mercury = Mercury.new
  mercury.new_singleton 'echo-server' do |msg|
    puts "Got '#{msg.content}'"
    mercury.send_to(msg.sender, Ib::Echo::V1::Response.new(content: msg.content))
  end
  puts 'Listening...'
end
