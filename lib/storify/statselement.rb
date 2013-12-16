require 'ostruct'
require 'representable/json'

module Storify
  class StatsElement < OpenStruct

  end

  module StatsElementRepresentable
    include Representable::JSON

    property :text
    property :quote
    property :image
    property :video
    property :link
    property :other
  end
end