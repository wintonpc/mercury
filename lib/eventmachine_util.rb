require 'eventmachine'

module EM
  def self.on_keyboard_line(&block)
    buf = []
    open_keyboard(Module.new do
      define_method(:receive_data) do |char|
        if char.ord == 10
          block.(buf.join)
          buf = []
        else
          buf << char
        end
      end
    end)
  end
end
