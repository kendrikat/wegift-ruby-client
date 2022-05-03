# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'uri'

module Wegift
  class RemoteCode < Response
    attr_accessor :url

    # response/success
    attr_accessor :amount, :barcode_format, :barcode_string, :code, :expiry_date,
      :pin, :type

    def get(ctx)
      conn = Faraday.new(url: url) do |c|
        c.adapter :net_http
        c.use FaradayMiddleware::FollowRedirects, limit: 5
      end
      parse(conn.get("#{url}?format=json") { |r| r.headers['Accept'] = 'application/json' })
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
