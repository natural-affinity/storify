require 'ostruct'
require 'representable/json'

module Storify
  class UserAgency < OpenStruct

  end

  module UserAgencyRepresentable
    include Representable::JSON

    property :isAgency
    property :agencyInfo, :class => Storify::AgencyInfo, :extend => Storify::AgencyInfoRepresentable
    property :isCustomer
    property :customerInfo, :class => Storify::CustomerInfo, :extend => Storify::CustomerInfoRepresentable
  end
end