require_relative 'messaging'

class MutexClient

  def self.request_mutex(mercury, resource)
    ms = mercury.new_singleton do |response|
      ms.close
      yield(response.was_obtained ? response.release_token : nil)
    end
    mercury.publish 'mutex-requests', Ib::Mutex::V1::Request.new(requestor: ms.name, owner_name: ms.name, resource: resource)
  end

  def self.release(mercury, release_token, &block)
    mercury.publish('mutex-requests', Ib::Mutex::V1::Release.new(token: release_token), &block)
  end

end