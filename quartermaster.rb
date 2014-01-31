require_relative 'lib/messaging'
require File.join(File.dirname(__FILE__), 'lib/messaging')
require 'model/batch'
require 'mongoid'
require 'sinatra/base'

class App < Sinatra::Base
  configure do
    EM.next_tick {
      mercury = Mercury.new

      mercury.start_worker 'quartermaster-conversion-worker', 'convert-notifications' do |msg, ack|
        puts "got convert notification: #{WireSerializer.to_hash(msg)}"
        Mongoid.override_database("ascent_production_#{msg.request.site}")
        batch = Batch.where(name: msg.request.batch).first
        sample = batch.samples.first{|s| s.name == msg.request.sample}
        sample.is_converted = true
        batch.save!
        ack.()
      end

      set :mercury, mercury
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    site, batch_name, sample_names = msg['site'], msg['batch'], msg['samples']

    Mongoid.override_database("ascent_production_#{site}")
    batch = Batch.new(name: batch_name, samples: sample_names.map{|s| Sample.new(name: s, is_converted: false) })
    batch.save!

    sample_names.each do |sample_name|
      settings.mercury.publish('convert-requests',
                               Ib::ConverterService::V1::Request.new(site: site, batch: batch_name, sample: sample_name))
    end

    puts "added batch #{batch_name} to site #{site} with samples #{sample_names}\n"
    {success: true}.to_json
  end

end

App.run!
