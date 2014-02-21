require_relative 'lib/everything'

EM.run do
  client = Mercury.new.new_singleton
  client.request('echo-server', Ib::Echo::V1::Request.new(sender: client.name, content: ARGV[0])) do |response|
    puts "echoed: '#{response.content}'"
    EM.stop
  end
end
