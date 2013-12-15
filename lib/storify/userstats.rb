require 'ostruct'
require 'representable/json'

module Storify
  class UserStats < OpenStruct

  end

  module UserStatsRepresentable
    include Representable::JSON

    property :views
    property :subscriptions
    property :subscribers
    property :stories
    property :embeds
  end
end