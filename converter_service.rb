require_relative 'lib/messaging'

EM.run do
  mercury = Mercury.new
  mercury.start_worker 'convert-worker', 'convert-requests' do |msg, ack|
    puts "got request: #{WireSerializer.to_hash(msg)}"
    EM.add_timer(1) do # simulate work
      mercury.publish('convert-notifications', Ib::ConverterService::V1::Notification.new(success: true, request: msg))
      ack.()
    end
  end
end
