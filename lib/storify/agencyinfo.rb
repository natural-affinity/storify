require 'ostruct'
require 'representable/json'

module Storify
  class AgencyInfo < OpenStruct

  end

  module AgencyInfoRepresentable
    include Representable::JSON

    property :maxCustomersNum
    collection :customers
  end
end