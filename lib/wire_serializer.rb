require 'messages/common.pb'
require 'active_support/inflector'
require 'json'

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
      puts "got message: #{to_json(wire_msg)}"
      the_class = ruby_class_for_qualified_name(qualified_name_for_msg(wire_msg))
      the_class && the_class.decode(wire_msg.message_data)
    end

    def to_hash(obj)
      if obj.class.name =~ /^Ib::/
        attr_names = obj.instance_variables.map{|x| x.to_s.delete('@')}.select{|x| obj.respond_to?(x)}
        Hash[attr_names.map{|x| [x, to_hash(obj.send(x))]}]
      else
        obj
      end
    end

    def to_json(obj)
      JSON.dump(to_hash(obj))
    end

    def from_hash(klass, hash)
      obj = klass.new
      field_types = Hash[klass.instance_variable_get(:@fields).values.map{|f| [f.name, f.type]}]
      hash.each_pair do |k,v|
        attr_type = field_types[k.to_sym]
        field_value = attr_type.is_a?(Class) ? from_hash(attr_type, v) : v
        obj.send("#{k}=", field_value)
      end
      obj
    end

    def from_json(klass, json)
      from_hash(klass, JSON.load(json))
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