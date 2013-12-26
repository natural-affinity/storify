require 'ostruct'
require 'representable/json'

module Storify
  class StoryMeta < OpenStruct

  end

  module StoryMetaRepresentable
    include Representable::JSON

    collection :quoted, :class => Storify::Quotable, :extend => Storify::QuotableRepresentable
    collection :hashtags
    property :created_with, :class => lambda { |fragment, *| fragment.respond_to?(:has_key?) ? Storify::CreatedWith : String },
                            :extend => lambda { |name, *| name.is_a?(Storify::CreatedWith) ? Storify::CreatedWithRepresentable : Storify::StringRepresentable }
  end
end