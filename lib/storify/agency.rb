require 'ostruct'
require 'representable/json'

module Storify
  class UserAgency < OpenStruct

  end

  module UserAgencyRepresentable
    include Representable::JSON

    property :isAgency
    property :agencyInfo, :class => Storify::Agency::Info, :extend => Storify::Agency::InfoRepresentable
    property :isCustomer
    property :customerInfo, :class => Storify::Agency::CustomerInfo, :extend => Storify::Agency::CustomerInfoRepresentable
  end
end