require_relative 'response'

class Wegift::Order < Wegift::Response

  PATH = '/order-digital-card'

  DELIVERY_TYPE = {:direct => 'direct', :email => 'email'}

  # request/payload
  attr_accessor :product_code, :delivery, :amount, :currency_code, :external_ref

  # response/success
  attr_accessor :code, :expiry_date, :pin

  def initialize(options = {})
    @product_code = options[:product_code]
    @delivery = options[:delivery].eql?(DELIVERY_TYPE[:email]) ? options[:delivery] : DELIVERY_TYPE[:direct]
    @amount = options[:amount]
    @currency_code = options[:currency_code]
    @external_ref = options[:external_ref]
  end

  def payload
    {
        :product_code => @product_code,
        :delivery => @delivery,
        :amount => @amount,
        :currency_code => @currency_code,
        :external_ref => @external_ref,
    }
  end

  # Order Digital Card
  # POST /api/b2b-sync/v1/order-digital-card
  def post(ctx)
    response = ctx.post(PATH, self.payload)
    self.parse(JSON.parse(response.body))
  end

  def parse(data)
    super(data)

    # nested status/error object
    # assuming root "status" is always "SUCCESS" if "e_code" is set
    #{
    #  "e_code": {
    #    "error_code": "EC001",
    #    "error_string": "Error retrieving E-Code from data processor",
    #    "status": "ERROR"
    #   },
    #  "error_code": null,
    #  "error_details": null,
    #  "error_string": null,
    #  "order_id": 18,
    #  "status": "SUCCESS"
    #}

    # override root "status" if set
    if data['e_code'] && data['e_code']['status'].eql?(STATUS[:error])
      @status = data['e_code']['status']
      @error_code = data['e_code']['error_code'] unless data['e_code']['error_code'].blank?
      @error_string = data['e_code']['error_string'] unless data['e_code']['error_string'].blank?
      @error_details = data['e_code']['error_details'] unless data['e_code']['error_details'].blank?
    end

    # set valid data
    if data['e_code'] && data['e_code']['status'].eql?(STATUS[:success])
      @code = data['e_code']['code']
      @expiry_date = data['e_code']['expiry_date']
      @pin = data['e_code']['pin']
    end
  end

end
