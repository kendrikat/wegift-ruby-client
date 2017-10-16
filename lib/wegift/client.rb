# encoding: utf-8
require 'faraday'

module Wegift

  class Client
    attr_accessor :api_host, :api_path, :api_key, :api_secret, :connection

    # supported: basic-http-auth - see: http://sandbox.wegift.io

    def initialize(options = {})
      @api_host = options[:api_host] || 'http://sandbox.wegift.io'
      @api_path = options[:api_path] || '/api/b2b-sync/v1'
      @api_key = options[:api_key].to_s
      @api_secret = options[:api_secret]

      @connection = Faraday.new(:url => @api_host) do |c|
        c.basic_auth(@api_key, @api_secret)
        c.adapter Faraday.default_adapter
        c.options[:proxy] = {
            :uri => URI(options[:proxy])
        } unless options[:proxy].blank?
      end
    end

    # KISS since we have only one call!
    def post(path, payload = {})
      @connection.post do |req|
        req.url [@api_path, path].join('')
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
      end
    end

    # TODO: shared context/connection for all calls
    # keep client => https://github.com/lostisland/faraday#basic-use

  end

end
