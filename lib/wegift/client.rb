# frozen_string_literal: true

require 'faraday'

require_relative 'models/response'
require_relative 'models/product'
require_relative 'models/products'
require_relative 'models/order'
require_relative 'models/stock'

module Wegift
  class Client
    attr_accessor :api_host, :api_path, :api_key, :api_secret, :connection

    # supported: basic-http-auth - see: https://playground.wegift.io

    def initialize(options = {})
      @api_host = options[:api_host] || 'https://playground.wegift.io'
      @api_path = options[:api_path] || '/api/b2b-sync/v1'
      @api_key = options[:api_key].to_s
      @api_secret = options[:api_secret]

      @connection = Faraday.new(url: @api_host) do |c|
        c.basic_auth(@api_key, @api_secret)
        c.adapter Faraday.default_adapter
        unless options[:proxy].nil?
          c.options[:proxy] = {
            uri: URI(options[:proxy])
          }
        end
      end
    end

    def request(method, path, payload = {})
      @connection.send(method) do |req|
        req.url [@api_path, path].join
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json if method.to_sym.eql?(:post)
        req.params = payload if method.to_sym.eql?(:get)
      end
    end

    # TODO: shared context/connection for all calls
    # keep client => https://github.com/lostisland/faraday#basic-use

    # global methods

    def products
      products = Wegift::Products.new
      products.get(self)
    end

    def product(id = nil)
      products = Wegift::Product.new(product_code: id)
      products.get(self)
    end

    def order(options)
      order = Wegift::Order.new(options)
      order.post(self)
    end

    def stock(id)
      stock = Wegift::Stock.new(id: id)
      stock.get(self)
    end
  end
end
