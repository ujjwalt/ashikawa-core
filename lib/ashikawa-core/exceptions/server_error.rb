# -*- encoding : utf-8 -*-
module Ashikawa
  module Core
    # The server had an error during the request
    class ServerError < RuntimeError
      # Create a new instance
      #
      # @param [Fixnum] status_code
      # @return RuntimeError
      # @api private
      def initialize(status_code)
        @status_code = status_code
      end

      # String representation of the exception
      #
      # @return String
      # @api private
      def to_s
        @status_code
      end
    end
  end
end
