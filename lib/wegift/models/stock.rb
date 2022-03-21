# frozen_string_literal: true

class Wegift::Stock < Wegift::Response
  PATH = '/stock'

  # request/payload
  attr_reader :id

  # response/success
  attr_accessor :available_stock, :currency_code, :product_code, :product_name

  def initialize(params = {})
    @id = params[:id]
  end

  # Product Stock
  # GET /api/b2b-sync/v1/stock/ID
  def get(ctx)
    response = ctx.request(:get, path)
    parse(response)

    self
  end

  private

  def path
    [PATH, id.to_s].join('/')
  end

  def parse(response)
    super

    if is_successful?
      self.available_stock = payload['available_stock']
      self.currency_code = payload['currency_code']
      self.product_code = payload['product_code']
      self.product_name = payload['product_name']
    end
  end
end
