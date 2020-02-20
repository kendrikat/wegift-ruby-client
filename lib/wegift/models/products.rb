# frozen_string_literal: true

class Wegift::Products < Wegift::Response
  PATH = '/products'

  attr_accessor :all

  # Product Details List
  # GET /api/b2b-sync/v1/products/
  def get(ctx)
    response = ctx.request(:get, PATH)
    parse(response)
  end

  # Find all products by fieldname.
  def find(name, value)
    Wegift::Products.new(all: all.select! { |p| p.send(name).eql?(value) })
  end

  def parse(response)
    super(response)

    if is_successful?
      # TODO: separate?
      if @payload['products']
        @all = @payload['products'].map { |p| Wegift::Product.new(p) }
      end
    else
      @all = []
    end

    self
  end
end
