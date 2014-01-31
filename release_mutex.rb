require_relative 'lib/messaging'
require 'mutex_client'
require 'time'
require 'ap'

EM.run do
  MutexClient.release(Mercury.new, ARGV[0]) { EM.stop }
end
