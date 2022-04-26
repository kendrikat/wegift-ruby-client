# frozen_string_literal: true

require 'faraday'
require 'uri'

module Wegift
  class RemoteCode < Response
    attr_accessor :url

    # response/success
    attr_accessor :amount, :barcode_format, :barcode_string, :code, :expiry_date,
      :pin, :type

    def get(ctx)
      parse(Faraday.get("#{url}?format=json"))
    end

    def parse(response)
      super

      if is_successful?
        self.class.new(@payload['e_code'])
      else
        self
      end
    end
  end
end
