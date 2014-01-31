require_relative 'lib/messaging'

def show_prompt; EM.next_tick { print '> '; }; end

EM.run do

  show_prompt

  mercury = Mercury.new
  ms = mercury.new_singleton do |msg|
    puts "echoed: '#{msg.content}'"
    show_prompt
  end

  EM.on_keyboard_line do |line|
    mercury.send_to('echo-service', Ib::Echo::V1::Request.new(sender: ms.name, content: line))
  end

end

