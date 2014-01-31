## Generated from ib/mutex/v1/messages.proto for ib.mutex.v1
require "beefcake"

module Ib
  module Mutex
    module V1

      class Request
        include Beefcake::Message
      end

      class Response
        include Beefcake::Message
      end

      class Release
        include Beefcake::Message
      end

      class Request
        required :requestor, :string, 1
        required :owner_name, :string, 2
        required :resource, :string, 3
      end

      class Response
        required :request, Request, 1
        optional :release_token, :string, 2
        required :was_obtained, :bool, 3
        required :obtained_abandoned, :bool, 4
      end

      class Release
        required :token, :string, 1
      end
    end
  end
end
