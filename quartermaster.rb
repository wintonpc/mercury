require_relative 'lib/messaging'
require 'sinatra/synchrony'
require File.join(File.dirname(__FILE__), 'lib/messaging')
require 'model/batch'

class App < Sinatra::Base

  configure do
    EM.next_tick {
      set :ms, Mercury.new.new_singleton
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    # add_batch_to_mongo(msg)
    text = "acknowledging batch #{msg['batch']} with samples #{msg['samples']}\n"
    settings.ms.send_to('testq', Ib::Echo::V1::Response.new(content: text))
    text
  end

end

App.run!
