require_relative 'response'

class Wegift::Products < Wegift::Response

  PATH = '/products'

  # Product Details List
  # GET /api/b2b-sync/v1/products/
  def get(ctx)
    response = ctx.request(:get, PATH)
    self.parse(JSON.parse(response.body))
  end

  def parse(data)
    super(data)

    # TODO separate?
    if data['products']
      data['products'].map{|p| Wegift::Product.new(p)}
    end
  end

end
