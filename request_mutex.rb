require_relative 'lib/messaging'
require 'time'

EM.run do
  mercury = Mercury.new
  mercury.publish 'mutex-requests', Ib::Mutex::V1::Request.new(sender: '', owner_name: 'peter', resource: 'batches/ABC') do
    EM.stop
  end
end
