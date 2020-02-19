# frozen_string_literal: true

class Wegift::Product < Wegift::Response
  PATH = '/products'

  # request/payload
  attr_accessor :product_code

  # response/success
  attr_accessor :code, :name, :description, :currency_code, :availability,
                :denomination_type, :minimum_value, :maximum_value,
                :card_image_url, :expiry_date_policy,
                :redeem_instructions_html,
                :terms_and_conditions_html,
                :terms_and_conditions_url,
                :terms_and_conditions_pdf_url,
                :e_code_usage_type

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
    parse(response)
  end

  def parse(response)
    super(response)
    Wegift::Product.new(@payload)
  end
end
