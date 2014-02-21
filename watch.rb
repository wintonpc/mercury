require_relative 'lib/everything'


COLORS = [:red, :cyan, :green, :yellow, :purple, :brown]
COLORMAP = {}

def watch(mercury, source_name)
  mercury.start_listener(source_name) do |msg|
    dump_message(msg, get_color(source_name))
  end
end

def get_color(source_name)
  COLORMAP[source_name] || (COLORMAP[source_name] = COLORS.shift)
end

EM.run do
  mercury = Mercury.new
  ARGV.each { |source_name| watch(mercury, source_name) }
end
