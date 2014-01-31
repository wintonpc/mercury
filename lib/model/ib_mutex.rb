require 'mongoid'

class IbMutex
  include Mongoid::Document

  field :resource, type: String
  field :held, type: Boolean
  field :last_obtained, type: DateTime
  field :owner, type: String
  field :release_token, type: String
end
