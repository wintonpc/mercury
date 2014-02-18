require_relative 'lib/messaging'
require 'eventmachine'

EM.run do
  Mercury::EM.start_message_server(7890) do |request, respond|
    respond.(Ib::Mutex::V1::Response.new(request: request, release_token: 'foo',
                                         was_obtained: false, obtained_abandoned: false))
  end
  puts 'Listening...'
end
