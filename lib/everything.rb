$LOAD_PATH << File.absolute_path(File.dirname(__FILE__))

def require_recursive(basepath)
  Dir.glob(File.join(File.dirname(__FILE__), "#{basepath}/**/*.rb")).each{|path| require_relative(path)}
end

require 'mercury'
require 'messages'
require 'messaging'
require 'eventmachine'
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

require 'mongoid'
ENV['MONGOID_ENV'] = 'development'
Mongoid.load!('config/mongoid.yml')
