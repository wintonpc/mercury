require 'ap'
require 'colorize'

def dump_message(msg, color=nil)
  puts
  puts msg.class.to_s.colorize(color || :red)
  ap WireSerializer.to_hash(msg), sort_keys: true
end