require_relative 'lib/everything'

EM.run do
  mercury = Mercury.new
  mercury.start_worker 'housekeeper-batch-worker', 'batch-loads' do |msg, ack|
    puts "housekeeper is converting batch #{msg.batch_name}"
    ack.()
  end
end
