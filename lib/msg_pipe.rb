require 'bin_buf'

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
    [payload.bytesize].pack('N') + payload
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
