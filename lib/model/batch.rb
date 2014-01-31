require 'mongoid'

class Batch
  include Mongoid::Document

  field :name
  embeds_many :samples
end

class Sample
  include Mongoid::Document
  embedded_in :batch

  field :name
  field :is_converted
end
