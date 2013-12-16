require 'ostruct'
require 'representable/json'

module Storify
  class Source < OpenStruct

  end

  module SourceRepresentable
    include Representable::JSON

    property :href
    property :name
    property :userid
    property :username
  end
end