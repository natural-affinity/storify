require 'ostruct'
require 'representable/json'

module Storify
  class StatsEmbed < OpenStruct

  end

  module StatsEmbedRepresentable
    include Representable::JSON

    property :clicks
    property :views
    property :href
    property :domain
  end
end