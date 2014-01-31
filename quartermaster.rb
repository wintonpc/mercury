require_relative 'lib/messaging'
require 'sinatra/synchrony'
require File.join(File.dirname(__FILE__), 'lib/messaging')
require 'model/batch'
require 'mongoid'

Mongoid.load!('config/mongoid.yml')

class App < Sinatra::Base
  register Sinatra::Synchrony

  configure do
    EM.next_tick {
      mercury = Mercury.new
      mercury.start_worker 'quartermaster-conversion-worker', 'convert-notifications',
                           &App.method(:handle_convert_notification)

      set :mercury, mercury
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    site, batch, samples = msg['site'], msg['batch'], msg['samples']
    insert_batch(site, batch, samples)
    msg['samples'].each do |sample_name|
      settings.mercury.publish('convert-requests',
                               Ib::ConverterService::V1::Request.new(site: site, batch: batch, sample: sample_name))
    end
    puts "inserted batch #{batch} in site #{site} with samples #{samples}\n"
    {success: true}.to_json
  end

  def insert_batch(site, batch_name, sample_names)
    Mongoid.override_database("ascent_production_#{site}")
    batch = Batch.new(name: batch_name, samples: sample_names.map{|s| Sample.new(name: s, is_converted: false) })
    batch.save!
  end

  def self.handle_convert_notification(msg, ack)
    puts "got convert notification: #{WireSerializer.to_hash(msg)}"
    ack.()
  end

end

App.run!
