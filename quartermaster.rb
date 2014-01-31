require_relative 'lib/messaging'
require 'sinatra/synchrony'
require File.join(File.dirname(__FILE__), 'lib/messaging')
require 'model/batch'
require 'mongoid'

class App < Sinatra::Base
  register Sinatra::Synchrony

  configure do
    EM.next_tick {
      Mongoid.load!("config/mongoid.yml")
      mercury = Mercury.new
      #mercury.start_worker 'quartermaster-conversion-worker', &method(handle_convert_notification)

      set :mercury, mercury
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    insert_batch(msg['site'], msg['batch'], msg['samples'])
    "inserted batch #{msg['batch']} in site #{msg['site']} with samples #{msg['samples']}\n"
  end

  def insert_batch(site, batch_name, sample_names)
    Mongoid.override_database("ascent_production_#{site}")
    batch = Batch.new(name: batch_name, samples: sample_names.map{|s| Sample.new(name: s, is_converted: false) })
    batch.save!
  end

  def handle_convert_notification(msg)

  end

end

App.run!
