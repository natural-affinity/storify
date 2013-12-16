require 'ostruct'
require 'representable/json'

module Storify
  class Quotable < OpenStruct

  end

  module QuotableRepresentable
    include Representable::JSON

    property :username
    property :name
    property :avatar
    property :source
    property :notified_at, :render_nil => true
  end
end