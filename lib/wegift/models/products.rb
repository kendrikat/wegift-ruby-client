class Wegift::Products < Wegift::Response

  PATH = '/products'

  attr_accessor :all

  # Product Details List
  # GET /api/b2b-sync/v1/products/
  def get(ctx)
    response = ctx.request(:get, PATH)
    self.parse(response)
  end

  def parse(response)
    super(response)

    if self.is_successful?
      # TODO separate?
      if @payload['products']
        @all = @payload['products'].map{|p| Wegift::Product.new(p)}
      end
    else
      @all = []
    end

    self
  end

end
