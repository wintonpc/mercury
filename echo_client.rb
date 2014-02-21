require_relative 'lib/messaging'

def show_prompt; EM.next_tick { print '> '; }; end

EM.run do

  ms = Mercury.new.new_singleton

  show_prompt

  EM.on_keyboard_line do |line|
    ms.request('echo-service', Ib::Echo::V1::Request.new(sender: ms.name, content: line)) do |msg|
      puts "echoed: '#{msg.content}'"
      show_prompt
    end
  end

end

