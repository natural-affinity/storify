require 'ostruct'
require 'representable/json'

module Storify
  class StoryMeta < OpenStruct

  end

  module StoryMetaRepresentable
    include Representable::JSON

    collection :quoted, :class => Storify::Quotable, :extend => Storify::QuotableRepresentable
    collection :hashtags
    property :created_with, :class => Storify::CreatedWith, :extend => Storify::CreatedWithRepresentable
  end
end