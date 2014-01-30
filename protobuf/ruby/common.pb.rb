## Generated from ib/common.proto for ib
require "beefcake"

module Ib

  class WireMessage
    include Beefcake::Message
  end

  class WireMessage
    required :wire_version, :int32, 1
    required :interface_name, :string, 2
    required :interface_version, :int32, 3
    required :message_type, :string, 4
    required :message_data, :bytes, 5
  end
end
