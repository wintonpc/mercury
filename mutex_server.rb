require_relative 'lib/messaging'
require 'model/ib_mutex'
require 'time'
require 'mongoid'
require 'securerandom'

ENV['MONGOID_ENV'] = 'development'
Mongoid.load!('config/mongoid.yml')

EM.run do
  mercury = Mercury.new
  mercury.start_worker 'mutex-server', 'mutex-requests' do |msg, ack|

    m = IbMutex.
        where(resource: msg.resource).
        find_and_modify({'$setOnInsert' => { resource: msg.resource, held: false }}, upsert: true, new: true)

    puts "got request for #{msg.resource}"
    timeout = 30 * 1000
    pred = "function() { return !this.held || (ISODate() - this.last_obtained) > #{timeout}; }"
    release_token = SecureRandom.uuid
    request_time = DateTime.now
    updated_mutex = IbMutex.
        where(_id: m.id, '$where' => pred).
        find_and_modify({
                            '$set' => {
                                held: true,
                                owner: msg.owner_name,
                                last_obtained: request_time,
                                release_token: release_token
                            }
                        })
    puts "updated?: #{updated_mutex ? updated_mutex.attributes : 'no'}"
    was_obtained = !updated_mutex.nil?
    was_abandoned = updated_mutex && updated_mutex.held && request_time - updated_mutex.last_obtained > timeout
    mercury.send_to msg.requestor, Ib::Mutex::V1::Response(request: msg,
                                                           was_obtained: was_obtained,
                                                           obtained_abandoned: was_abandoned,
                                                           release_token: was_obtained ? nil : release_token)
    ack.()
  end
end
