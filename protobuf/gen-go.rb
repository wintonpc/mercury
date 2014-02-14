require 'fileutils'
require 'active_support/inflector'
require 'colorize'

Dir.glob('protos/ib/**/*.proto').each do |proto_path|
  proto_dir = File.dirname(proto_path).sub(/^protos\//, '')

  out_dir = "./go/#{proto_dir.sub(/^ib\/?/, '')}"
  FileUtils.mkdir_p "#{out_dir}"

  cmd = "protoc --go_out go --proto_path=protos #{proto_path}"
  result = system(cmd) ? '✔'.green : '✘'.red
  puts "#{result} #{cmd}"
end