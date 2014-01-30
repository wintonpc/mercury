require_relative 'lib/messaging'

Mercury.request('echo-service', ->(sender){Ib::Echo::V1::Request.new(sender: sender, content: ARGV[0])}) do |response|
  puts "echoed: '#{response.content}'"
end
