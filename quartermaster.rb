require_relative 'lib/messaging'
require 'sinatra/synchrony'
require File.join(File.dirname(__FILE__), 'lib/messaging')
require 'model/batch'
require 'mongoid'
require 'em-synchrony/mongo'

Mongoid.load!('config/mongoid.yml')

class App < Sinatra::Base
  register Sinatra::Synchrony

  configure do
    EM.next_tick {
      mercury = Mercury.new

      mercury.start_worker 'quartermaster-conversion-worker', 'convert-notifications' do |msg, ack|
        #puts "got convert notification: #{WireSerializer.to_hash(msg)}"
        #batch = Batch.where(name: msg.request.batch).first
        #sample = batch.samples.first{|s| s.name == msg.request.sample}
        #sample.is_converted = true
        #batch.save!
        #ack.()
        puts "got msg on #{Fiber.current}"
        batch = Fiber.new { Batch.where(name: msg.request.batch).first }.resume
        sample = batch.samples.first{|s| s.name == msg.request.sample}
        sample.is_converted = true
        batch.save!
      end

      set :mercury, mercury
    }
  end

  post '/upload' do
    msg = JSON.parse(request.body.read)
    site, batch, samples = msg['site'], msg['batch'], msg['samples']

    Mongoid.override_database("ascent_production_#{site}")
    batch = Batch.new(name: batch, samples: samples.map{|s| Sample.new(name: s, is_converted: false) })
    batch.save!

    samples.each do |sample|
      settings.mercury.publish('convert-requests', Ib::ConverterService::V1::Request.new(site: site, batch: batch, sample: sample))
    end

    puts "added batch #{batch} to site #{site} with samples #{samples}\n"
    {success: true}.to_json
  end

end

App.run!
