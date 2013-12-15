require 'ostruct'
require 'representable/json'

module Storify
  module Agency
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
      property :keys, :class => Storify::Agency::CustomerInfoKeys, :extend => Storify::Agency::CustomerInfoKeysRepresentable
    end
  end
end