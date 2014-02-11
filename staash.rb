require_relative 'lib/messaging'
require 'eventmachine'
require 'ap'

class BinBuf
  def initialize
    @chunks = []
  end

  def write(bytes)
    @chunks << bytes
  end

  def unread_uint(uint)
    @chunks.unshift([uint].pack('L'))
  end

  def read_uint
    bytes = read(4)
    bytes ? bytes.unpack('L').first : nil
  end

  def read(num_to_read)
    chunks = []
    byte_count = 0

    while @chunks.any? && byte_count < num_to_read
      chunk = @chunks.shift
      byte_count += chunk.bytesize
      chunks << chunk
    end


    if byte_count < num_to_read
      @chunks.unshift(*chunks)
      nil
    else
      joined_chunks = chunks.join
      a = joined_chunks.byteslice(0, num_to_read)
      b = joined_chunks.byteslice(num_to_read, joined_chunks.bytesize)

      @chunks.unshift(b) if b.bytesize > 0
      a
    end
  end
end


class MsgPipe
  def initialize(&on_msg)
    @on_msg = on_msg
    @buf = BinBuf.new
  end

  def pipe_in(bytes)
    @buf.write(bytes)
    while payload = read_payload(@buf)
      begin
        msg = WireSerializer.read(payload)
      rescue
        puts "Dropped unreadable payload: #{payload}"
      end
      @on_msg.(msg)
    end
  end

  def self.write(msg)
    payload = WireSerializer.write(msg)
    [payload.bytesize].pack('L') + payload
  end

  private

  def read_payload(buf)
    payload_size = buf.read_uint
    return nil unless payload_size

    payload = buf.read(payload_size)
    if payload
      payload
    else
      buf.unread_uint(payload_size)
      nil
    end
  end
end

module Handler
  def post_init
    @pipe = MsgPipe.new(&method(:receive_msg))
  end

  def receive_data(bytes)
    pipe.write(bytes)
  end

  def receive_msg(msg)
  end

  def unbind

  end
end

#EM.run do
#  EM.start_server '0.0.0.0', 7890, Handler
#end

mp = MsgPipe.new {|msg| ap msg}
bs = MsgPipe.write Ib::Mutex::V1::Request.new(requestor: 'req', owner_name: 'own', resource: 'res')
mp.pipe_in(bs)
