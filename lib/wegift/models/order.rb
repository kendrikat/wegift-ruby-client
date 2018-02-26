class Wegift::Order < Wegift::Response

  PATH = '/order-digital-card'

  DELIVERY_METHODS = {:direct => 'direct', :email => 'email'}
  DELIVERY_FORMATS = {:code => 'raw', :url => 'url-instant'}

  # request/payload
  attr_accessor :product_code, :currency_code, :amount, :delivery_method, :delivery_format,
                :notification_email, :delivery_email, :external_ref

  # response/success
  attr_accessor :code, :expiry_date, :pin, :order_id, :cvc2, :delivery_url

  def initialize(params = {})
    super(params)
    # default/fallback: 'direct'/'raw'
    @delivery_method = params[:delivery_method] || DELIVERY_METHODS[:direct]
    @delivery_format = params[:delivery_format] || DELIVERY_FORMATS[:code]
  end

  def payload
    {
        :product_code => @product_code,
        :currency_code => @currency_code,
        :amount => @amount,
        :delivery_method => @delivery_method,
        :delivery_format => @delivery_format,
        :notification_email => @notification_email,
        :delivery_email => @delivery_email,
        :external_ref => @external_ref,
    }
  end

  # Order Digital Card
  # POST /api/b2b-sync/v1/order-digital-card
  def post(ctx)
    response = ctx.request(:post, PATH, self.payload)
    self.parse(response)
  end

  def parse(response)
    super(response)

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
    if @payload['e_code'] && @payload['e_code']['status'].eql?(STATUS[:error])
      @status = @payload['e_code']['status']
      @error_code = @payload['e_code']['error_code'] unless @payload['e_code']['error_code'].blank?
      @error_string = @payload['e_code']['error_string'] unless @payload['e_code']['error_string'].blank?
      @error_details = @payload['e_code']['error_details'] unless @payload['e_code']['error_details'].blank?
    end

    # set valid data
    if @payload['e_code'] && @payload['e_code']['status'].eql?(STATUS[:success])
      @code = @payload['e_code']['code']
      @expiry_date = @payload['e_code']['expiry_date']
      @pin = @payload['e_code']['pin']
      @cvc2 = @payload['e_code']['cvc2']
      @delivery_url = @payload['e_code']['delivery_url']
    end

    @order_id = @payload['order_id']

    self
  end

end
