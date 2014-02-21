require_relative './chunk_buffer'

class MessagePipe
  def initialize(&on_msg)
    @on_msg = on_msg
    @buf = ChunkBuffer.new
  end

  def write(bytes)
    @buf.write(bytes)
    while msg_bytes = @buf.read_chunk
      begin
        msg = WireSerializer.read(msg_bytes)
      rescue
        puts "Dropped unreadable payload: #{msg_bytes}"
      end
      @on_msg.(msg)
    end
  end

  def self.message_to_bytes(msg)
    ChunkBuffer.write_chunk(WireSerializer.write(msg))
  end
end
