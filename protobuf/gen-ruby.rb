require 'fileutils'
require 'active_support/inflector'

Dir.glob('protos/ib/**/*.proto').each do |proto_path|
  proto_dir = File.dirname(proto_path).sub(/^protos\//, '')

  namespace = proto_dir.split(/\//).map(&:classify).join('::')
  out_dir = "./ruby/#{proto_dir.sub(/^ib\/?/, '')}"
  FileUtils.mkdir_p "#{out_dir}"

  cmd = "BEEFCAKE_NAMESPACE=#{namespace} protoc --beefcake_out #{out_dir} --proto_path=protos #{proto_path}"
  result = system(cmd) ? 'SUCCESS' : 'FAILED '
  puts "#{result} #{cmd}"
end