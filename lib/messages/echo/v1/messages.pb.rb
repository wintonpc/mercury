## Generated from ib/echo/v1/messages.proto for ib.echo.v1
require "beefcake"

module Ib
  module Echo
    module V1

      class Request
        include Beefcake::Message
      end

      class Response
        include Beefcake::Message
      end

      class Request
        required :sender, :string, 1
        required :content, :string, 2
      end

      class Response
        required :content, :string, 1
      end
    end
  end
end
