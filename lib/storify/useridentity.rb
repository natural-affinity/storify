require 'ostruct'
require 'representable/json'

module Storify
  class UserIdentity < OpenStruct
  end

  module UserIdentityRepresentable
    include Representable::JSON

    property :service
    property :username
    property :name
    property :date, :class => Storify::DateGroup, :extend => Storify::DateGroupRepresentable
    property :url
    property :avatar
  end
end