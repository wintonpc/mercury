require_relative 'lib/messaging'
require 'model/ib_mutex'
require 'time'
require 'mongoid'
require 'securerandom'

ENV['MONGOID_ENV'] = 'development'
Mongoid.load!('config/mongoid.yml')

class MutexServer

  def start
    EM.run do
      @mercury = Mercury.new
      @mercury.start_worker 'mutex-server', 'mutex-requests' do |msg, ack|
        case msg
          when Ib::Mutex::V1::Request
            handle_request(msg, ack)
          when Ib::Mutex::V1::Release
            handle_release(msg, ack)
          else
            puts "Unexpected message: #{msg.class.name}"
        end
      end
    end
  end

  def handle_request(msg, ack)
    m = IbMutex.
        where(resource: msg.resource).
        find_and_modify({'$setOnInsert' => { resource: msg.resource, held: false }}, upsert: true, new: true)

    puts "got request for #{msg.resource}"
    timeout = 10 * 1000
    pred = "function() { return !this.held || (ISODate() - this.last_obtained) > #{timeout}; }"
    release_token = SecureRandom.uuid
    request_time = Time.now
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

    was_obtained = !updated_mutex.nil?
    was_abandoned = was_obtained && updated_mutex.held && ((request_time - updated_mutex.last_obtained) * 1000).to_i > timeout
    @mercury.send_to msg.requestor, Ib::Mutex::V1::Response.new(request: msg,
                                                               was_obtained: was_obtained,
                                                               obtained_abandoned: was_abandoned,
                                                               release_token: was_obtained ? release_token : nil)
    ack.()
  end

  def handle_release(release_msg, ack)
    old = IbMutex.where(release_token: release_msg.token, held: true).find_and_modify({ '$set' => { held: false } })
    puts "released #{old.resource}" if old
    ack.()
  end
end

MutexServer.new.start