require_relative 'response'

class Wegift::Product < Wegift::Response

  PATH = '/products'

  # request/payload
  attr_accessor :product_code

  # response/success
  attr_accessor :code, :name, :description, :currency_code, :availability,
                :denomination_type, :minimum_value, :maximum_value,
                :card_image_url, :terms_and_conditions_url, :expiry_date_policy

  def initialize(params = {})
    super
  end

  def path
    [PATH, @product_code.to_s].join('/')
  end

  # Product Details List
  # GET /api/b2b-sync/v1/products/ID
  def get(ctx)
    response = ctx.request(:get, path)
    self.parse(JSON.parse(response.body))
  end

  def parse(data)
    super(data)
    Wegift::Product.new(data)
  end

end