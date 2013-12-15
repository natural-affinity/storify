require 'ostruct'
require 'representable/json'

module Storify
  class Identity < OpenStruct
  end

  module IdentityRepresentable
    include Representable::JSON

    property :service
    property :username
    property :name
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    property :url
    property :avatar
  end
end