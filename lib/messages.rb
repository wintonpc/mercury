Dir.glob(File.join(File.dirname(__FILE__), 'messages/**/*.rb')).each{|path| require_relative(path)}

EchoRequest = Ib::Echo::V1::Request
EchoResponse = Ib::Echo::V1::Response
