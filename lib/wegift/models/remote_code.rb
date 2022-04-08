# frozen_string_literal: true

require 'faraday'
require 'uri'

module Wegift
  class RemoteCode < Response
    attr_reader :url

    # response/success
    attr_reader :amount, :barcode_format, :barcode_string, :code, :expiry_date,
      :pin, :type

    def initialize(url:)
      @url = url
    end

    def self.get(url)
      uri = URI(url)
      conn = Faraday.new(url: "#{uri.scheme}://#{uri.host}")

      response =  conn.get("#{uri.path}?format=json") do |req|
        req.headers['Content-Type'] = 'application/json'
      end

      remote_code = self.new(url: url)
      remote_code.parse(response)

      remote_code
    end

    def parse(response)
      super

      if is_successful?
        @amount = @payload['e_code']['amount']
        @barcode_format = @payload['e_code']['barcode_format']
        @barcode_string = @payload['e_code']['barcode_string']
        @code = @payload['e_code']['code']
        @expiry_date = @payload['e_code']['expiry_date']
        @pin = @payload['e_code']['pin']
        @type = @payload['e_code']['type']
      end
    end
  end
end
