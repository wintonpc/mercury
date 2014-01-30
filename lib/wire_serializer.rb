require 'messages/common.pb'
require 'active_support/inflector'

class WireSerializer
  class << self
    def write(msg)
      qualified_name = qualified_name_for_class(msg)
      matches = qualified_name.match(/^ib\.(?<interface>\w+)\.v(?<version>\d+)\.(?<name>\w+)$/)
      Ib::WireMessage.new(wire_version: 1,
                          interface_name: matches[:interface],
                          interface_version: matches[:version].to_i,
                          message_type: matches[:name],
                          message_data: msg.encode.to_s).encode.to_s
    end

    # returns nil if no corresponding class found
    def read(bytes)
      my_bytes = bytes.clone
      wire_msg = Ib::WireMessage.decode(my_bytes)
      the_class = ruby_class_for_qualified_name(qualified_name_for_msg(wire_msg))
      the_class && the_class.decode(wire_msg.message_data)
    end

    private ##########################################################

    def qualified_name_for_class(msg)
      toks = msg.class.to_s.split('::')
      class_name = toks.pop
      namespace = toks.map{|x| x.camelize(:lower)}.join('.')
      [namespace, class_name].join('.')
    end

    def qualified_name_for_msg(wire_msg)
      "ib.#{wire_msg.interface_name}.v#{wire_msg.interface_version}.#{wire_msg.message_type}"
    end

    # returns nil if no corresponding class found
    def ruby_class_for_qualified_name(qualified_name)
      begin
        qualified_name.split('.').map{|x| x.classify}.join('::').constantize
      rescue
        nil
      end
    end

  end
end