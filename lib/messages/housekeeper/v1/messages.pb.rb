## Generated from ib/housekeeper/v1/messages.proto for ib.housekeeper.v1
require "beefcake"

module Ib
  module Housekeeper
    module V1

      class BatchLoaded
        include Beefcake::Message
      end

      class BatchLoaded
        required :site, :string, 1
        required :batch_name, :string, 2
      end
    end
  end
end
