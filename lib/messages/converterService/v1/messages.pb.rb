## Generated from ib/converterService/v1/messages.proto for ib.converterService.v1
require "beefcake"

module Ib
  module ConverterService
    module V1

      class Request
        include Beefcake::Message
      end

      class Notification
        include Beefcake::Message
      end

      class Request
        required :site, :string, 1
        required :batch, :string, 2
        required :sample, :string, 3
      end

      class Notification
        required :success, :bool, 1
        required :request, Request, 2
      end
    end
  end
end
