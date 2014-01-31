require_relative 'lib/messaging'
require 'time'
require 'ap'

def request_mutex(mercury, resource)
  ms = mercury.new_singleton do |response|
    yield(response.was_obtained ? response.release_token : nil)
  end
  mercury.publish 'mutex-requests', Ib::Mutex::V1::Request.new(requestor: ms.name, owner_name: ms.name, resource: resource)
end

EM.run do
  request_mutex(Mercury.new, ARGV[0]) do |release_token|
    if release_token
      puts "obtained? yes. release token: #{release_token}"
    else
      puts 'obtained? no.'
    end
    EM.stop
  end
end
