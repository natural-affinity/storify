require 'ostruct'
require 'representable/json'

module Storify
  class Attribution < OpenStruct

  end

  module AttributionRepresentable
    include Representable::JSON

    property :title
    property :name
    property :username
    property :href
    property :thumbnail
  end
end