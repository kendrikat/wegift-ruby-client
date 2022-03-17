# frozen_string_literal: true

class Wegift::Stock < Wegift::Response
  PATH = '/stock'

  # request/payload
  attr_accessor :product_code

  # response/success
  attr_accessor :available_stock, :currency_code, :product_code, :product_name

  def initialize(params = {})
    super
  end

  def path
    [PATH, product_code.to_s].join('/')
  end

  # Product Stock
  # GET /api/b2b-sync/v1/stock/ID
  def get(ctx)
    response = ctx.request(:get, path)
    parse(response)
  end

  def parse(response)
    super

    self
  end
end
