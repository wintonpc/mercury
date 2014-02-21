require_relative 'lib/everything'
require 'model/batch'
require 'mongoid'
require 'sinatra/base'

ConvertRequest = Ib::ConverterService::V1::Request

class App < Sinatra::Base

  configure do
    EM.next_tick {
      mercury = Mercury.new
      set :mercury, mercury
      start_conversion_listener(mercury)
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    site, batch_name, sample_names = msg['site'], msg['batch'], msg['samples']

    Mongoid.override_database("ascent_production_#{site}")
    Batch.create!(name: batch_name, samples: sample_names.map{|s| Sample.new(name: s, is_converted: false)})

    sample_names.each do |sample_name|
      settings.mercury.publish('convert-requests', ConvertRequest.new(site: site, batch: batch_name, sample: sample_name))
    end

    puts "added batch #{batch_name} to site #{site} with samples #{sample_names}\n"
    {success: true}.to_json
  end

  def self.start_conversion_listener(mercury)
    mercury.start_worker 'quartermaster-conversion-worker', 'convert-notifications' do |msg, ack|
      puts "got convert notification: #{WireSerializer.to_hash(msg)}"
      Mongoid.override_database("ascent_production_#{msg.request.site}")
      batch = Batch.where(name: msg.request.batch).first
      sample = batch.samples.first{|s| s.name == msg.request.sample}
      sample.is_converted = true
      batch.save!
      ack.()
    end
  end

end

App.run!
