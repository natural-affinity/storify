require 'ostruct'
require 'representable/json'

module Storify
  class CreatedWith < OpenStruct

  end

  module CreatedWithRepresentable
    include Representable::JSON

    property :href
    property :appname
    property :name
  end
end