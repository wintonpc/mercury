require_relative 'lib/messaging'
require 'eventmachine'
require 'ap'

CLIENT_COUNT = ARGV[0].to_i
MSG_COUNT = ARGV[1].to_i

puts "# clients: #{CLIENT_COUNT}"
puts "# msgs/client: #{MSG_COUNT}"

class Client < EM::Connection

  class << self
    def completed_client_count
      @completed_client_count ||= 0
    end

    def inc_completed_client_count
      @completed_client_count = completed_client_count + 1
    end
  end

  def post_init
    @pipe = MsgPipe.new(&method(:receive_msg))
    @count = 0
  end

  def receive_data(bytes)
    @pipe.pipe_in(bytes)
  end

  def request(req, &block)
    send_data(MsgPipe.write(req))
    @on_msg = block
  end

  def receive_msg(msg)
    if @on_msg
      handler = @on_msg
      @on_msg = nil # must clear before handler in case handler calls request()
      handler.(msg)
    else
      @count += 1
      if @count == MSG_COUNT
        Client.inc_completed_client_count
        if Client.completed_client_count == CLIENT_COUNT
          elapsed = Time.now - START
          puts "elapsed seconds: #{elapsed}"
          puts "milliseconds/msg: #{elapsed / (CLIENT_COUNT * MSG_COUNT) * 1000}"
          EM.stop
        end
      end
    end
  end
end

def average(xs)
  xs.inject{ |sum, el| sum + el }.to_f / xs.size
end

def roundtrip(client, remaining, latencies = [])
  request = Ib::Mutex::V1::Request.new(requestor: 'req', owner_name: 'own', resource: Time.now.iso8601(6))
  client.request(request) do |response|
    if remaining > 0
      roundtrip(client, remaining - 1, latencies.push(Time.now - Time.parse(response.request.resource)))
    else
      puts "average latency (ms): #{average(latencies) * 1000}"
      EM.stop
    end
  end
end

EM.run do
  client = EM.connect('127.0.0.1', 7890, Client)
  roundtrip(client, MSG_COUNT)
end

EM.run do
  msg = Ib::Mutex::V1::Request.new(requestor: 'req', owner_name: 'own', resource: 'res')
  START = Time.now
  CLIENT_COUNT.times do
    client = EM.connect('127.0.0.1', 7890, Client)
    MSG_COUNT.times { client.send_data(MsgPipe.write(msg)) }
  end
end
