$LOAD_PATH << File.absolute_path(File.dirname(__FILE__))

require 'eventmachine'
require 'mercury'
require 'messages'
require 'eventmachine_util'

# hack to fix equality failure in awesome_print
# beefcake's default == assumes the RHS is another beefcake message
module Beefcake
  module Message
    def ==(o)
      super
    end
  end
end