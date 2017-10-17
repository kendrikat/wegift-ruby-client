require_relative 'response'

class Wegift::Order < Wegift::Response

  PATH = '/order-digital-card'

  DELIVERY_METHODS = {:direct => 'direct', :email => 'email'}
  DELIVERY_FORMATS = {:code => 'raw', :url => 'url-instant'}

  # request/payload
  attr_accessor :product_code, :currency_code, :amount, :delivery_method, :delivery_format,
                :notification_email, :delivery_email, :external_ref

  # response/success
  attr_accessor :code, :expiry_date, :pin

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
        :delivery_format => delivery_format,
        :notification_email => @notification_email,
        :delivery_email => @delivery_email,
        :external_ref => @external_ref,
    }
  end

  # Order Digital Card
  # POST /api/b2b-sync/v1/order-digital-card
  def post(ctx)
    response = ctx.request(:post, PATH, self.payload)
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
