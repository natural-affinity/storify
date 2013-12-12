module Storify
  class ApiError < StandardError
    attr_reader :status, :type, :message

    def initialize(status, message, type = nil)
      @type = type
      @status = status
      @message = message
    end

    def to_s
      "#{self.status} #{self.type} #{self.message}"
    end
  end
end