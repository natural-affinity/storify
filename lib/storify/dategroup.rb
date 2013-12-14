require 'ostruct'
require 'representable/json'

module Storify
  class DateGroup < OpenStruct
  end

  module DateGroupRepresentable
    include Representable::JSON

    property :updated
    property :last_story
    property :last_seen
    property :last_email
    property :featured
    property :created
  end
end