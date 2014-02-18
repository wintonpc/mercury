require_relative 'lib/messaging'
require 'eventmachine'
require 'mercury_em_client'
require 'ap'

client_count = ARGV[0].to_i
msg_count = ARGV[1].to_i

puts "# clients: #{client_count}"
puts "# msgs/client: #{msg_count}"

def average(xs)
  xs.inject{ |sum, el| sum + el }.to_f / xs.size
end

def roundtrip(client, remaining, latencies = [])
  request = Ib::Mutex::V1::Request.new(requestor: 'req', owner_name: 'own', resource: Time.now.iso8601(6))
  client.send_request(request) do |response|
    if remaining > 0
      roundtrip(client, remaining - 1, latencies.push(Time.now - Time.parse(response.request.resource)))
    else
      puts "average latency (ms): #{average(latencies) * 1000}"
      EM.stop
    end
  end
end

EM.run do
  client = MercuryEMClient.new('127.0.0.1', 7890)
  roundtrip(client, msg_count)
end

start = Time.now
EM.run do
  msg = Ib::Mutex::V1::Request.new(requestor: 'req', owner_name: 'own', resource: 'res')
  completed_clients = 0
  client_count.times do
    completed_requests = 0
    client = MercuryEMClient.new('127.0.0.1', 7890) do
      completed_requests += 1
      completed_clients += 1 if completed_requests == msg_count
      EM.stop if completed_clients == client_count
    end
    msg_count.times { client.send_message(msg) }
  end
end
elapsed = Time.now - start
puts "milliseconds/msg: #{elapsed / (client_count * msg_count) * 1000}"
puts "messages/second: #{(client_count * msg_count) / elapsed}"
