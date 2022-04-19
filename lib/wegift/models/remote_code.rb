# frozen_string_literal: true

require 'faraday'
require 'uri'

module Wegift
  class RemoteCode < Response
    attr_accessor :url

    # response/success
    attr_accessor :amount, :barcode_format, :barcode_string, :code, :expiry_date,
      :pin, :type

    def self.get(url)
      uri = URI(url)
      conn = Faraday.new(url: "#{uri.scheme}://#{uri.host}")

      response =  conn.get("#{uri.path}?format=json") do |req|
        req.headers['Content-Type'] = 'application/json'
      end

      remote_code = self.new(url: url)
      remote_code = remote_code.parse(response)

      remote_code
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
