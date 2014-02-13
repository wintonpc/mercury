class BinBuf
  def initialize
    @chunks = []
  end

  def write(bytes)
    @chunks << bytes
  end

  def unread_uint(uint)
    @chunks.unshift([uint].pack('N'))
  end

  def read_uint
    bytes = read(4)
    bytes ? bytes.unpack('N').first : nil
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
