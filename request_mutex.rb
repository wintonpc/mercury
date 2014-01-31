require_relative 'lib/messaging'
require 'mutex_client'
require 'time'
require 'ap'

EM.run do
  MutexClient.request_mutex(Mercury.new, ARGV[0]) do |release_token|
    if release_token
      puts "obtained? yes. release token: #{release_token}"
    else
      puts 'obtained? no.'
    end
    EM.stop
  end
end
