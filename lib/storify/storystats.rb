require 'ostruct'
require 'representable/json'

module Storify
  class StoryStats < OpenStruct

  end

  module StoryStatsRepresentable
    include Representable::JSON

    property :views
    property :popularity
    property :likes
    collection :embeds, :class => StatsEmbed, :extend => StatsEmbedRepresentable
    property :elements, :class => StatsElement, :extend => StatsElementRepresentable
    property :elementComments
    property :comments
    property :clicks
  end
end