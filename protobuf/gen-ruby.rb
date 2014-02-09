require 'fileutils'
require 'active_support/inflector'
require 'colorize'

Dir.glob('protos/ib/**/*.proto').each do |proto_path|
  proto_dir = File.dirname(proto_path).sub(/^protos\//, '')

  namespace = proto_dir.split(/\//).map(&:classify).join('::')
  out_dir = "./ruby/#{proto_dir.sub(/^ib\/?/, '')}"
  FileUtils.mkdir_p "#{out_dir}"

  cmd = "protoc --beefcake_out #{out_dir} --proto_path=protos #{proto_path}"
  ENV['BEEFCAKE_NAMESPACE'] = namespace
  result = system(cmd) ? '✔'.green : '✘'.red
  puts "#{result} BEEFCAKE_NAMESPACE=#{namespace} #{cmd}"
end