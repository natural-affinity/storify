require 'representable/json'

module Storify
  module StringRepresentable
    include Representable::JSON

    def to_hash(*); self; end
    def from_hash(hsh, *args); hsh; end
  end
end