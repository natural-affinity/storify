require 'ostruct'
require 'representable/json'

module Storify
  class Options < OpenStruct

  end

  module OptionsRepresentable
    include Representable::JSON

    property :infinite_scroll
    property :hide_stats
    property :allow_embedding
    property :comments
    property :related_stories
    property :ga
  end
end