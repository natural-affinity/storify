require 'ostruct'
require 'representable/json'

module Storify
  class CustomerInfo < OpenStruct

  end

  module CustomerInfoRepresentable
    include Representable::JSON

    property :approved
    property :removalApproved
    property :agencyId, :render_nil => true
    property :agencyUsername, :render_nil => true
    property :approved_at, :render_nil => true
    property :paid_plan, :render_nil => true
    property :keys, :class => Storify::CustomerInfoKeys, :extend => Storify::CustomerInfoKeysRepresentable
  end
end