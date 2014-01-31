require_relative 'lib/messaging'
require 'time'
require 'ap'

EM.run do
  Mercury.new.publish('mutex-requests', Ib::Mutex::V1::Release.new(token: ARGV[0])) { EM.stop }
end
