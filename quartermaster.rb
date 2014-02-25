require_relative 'lib/everything'
require 'model/batch'
require 'mongoid'
require 'sinatra/base'

ConvertRequest = Ib::ConverterService::V1::Request
BatchLoaded = Ib::Housekeeper::V1::BatchLoaded

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
    Batch.create!(name: batch_name, version: 1, samples: sample_names.map{|s| Sample.new(name: s, is_converted: false)})

    sample_names.each do |sample_name|
      settings.mercury.publish('convert-requests', ConvertRequest.new(site: site, batch: batch_name, sample: sample_name))
    end

    puts "added batch #{batch_name} to site #{site} with samples #{sample_names}\n"
    {success: true}.to_json
  end

  def self.start_conversion_listener(mercury)
    mercury.start_worker 'quartermaster-conversion-worker', 'convert-notifications' do |msg, ack|
      puts "got convert notification: #{WireSerializer.to_hash(msg)}"
      req = msg.request
      Mongoid.override_database("ascent_production_#{req.site}")
      batch = Batch.where(name: req.batch).first
      sample = batch.samples.select{|s| s.name == req.sample}.first
      sample.is_converted = true
      batch.save!
      ack.()

      batch.reload
      if batch.samples.all?{|s| s.is_converted}
        MutexClient.request_mutex(mercury, "batch-load/#{req.site}/#{req.batch}/#{batch.version}") do |token|
          break unless token
          batch.version += 1
          batch.save!
          # do not release. consider it a oneshot
          mercury.publish 'batch-loads', BatchLoaded.new(site: req.site, batch_name: batch.name)
        end
      end
    end
  end

end

App.run!
