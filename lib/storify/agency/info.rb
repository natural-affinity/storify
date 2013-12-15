require 'ostruct'
require 'representable/json'

module Storify
  module Agency
    class Info < OpenStruct

    end

    module InfoRepresentable
      include Representable::JSON

      property :maxCustomersNum
      collection :customers
    end
  end
end