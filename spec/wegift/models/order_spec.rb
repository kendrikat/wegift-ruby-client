require 'spec_helper'

RSpec.describe Wegift::Order do

  def set_order(product_code, delivery_method, delivery_format,
                       amount, currency_code, external_ref)
    Wegift::Order.new(
        :product_code => product_code,
        :currency_code => currency_code,
        :amount => amount,
        :delivery_method => delivery_method,
        :delivery_format => delivery_format,
        #:notification_email => notification_email,
        #:delivery_email => delivery_email,
        :external_ref => external_ref,
    )
  end

  it 'should set payload' do
    order = set_order('1', 'direct', 'raw', '3', '4', '5')
    expect(order.product_code).to eq('1')
    expect(order.delivery_method).to eq('direct')
    expect(order.delivery_format).to eq('raw')
    expect(order.amount).to eq('3')
    expect(order.currency_code).to eq('4')
    expect(order.external_ref).to eq('5')
  end

  describe 'POST' do

    it 'should return error (404)' do
      client = set_wegift_client
      order = set_order('NOPE', '2', '3', '4', '5', '6')

      VCR.use_cassette('post_order_invalid_404') do
        order.post(client)

        expect(order.class).to eq(Wegift::Order)
        expect(order.is_successful?).to eq(false)
        expect(order.status).to eq(Wegift::Response::STATUS[:error])
        expect(order.error_string).to eq('Field has invalid value')
      end
    end

    it 'should return error (401)' do
      client = set_wegift_client
      order = set_order(
          'tTV',
          Wegift::Order::DELIVERY_METHODS[:direct],
          Wegift::Order::DELIVERY_FORMATS[:code],
          '0',
          'GBP',
          nil)

      VCR.use_cassette('post_order_invalid_401') do
        order.post(client)

        expect(order.class).to eq(Wegift::Order)
        expect(order.is_successful?).to eq(false)
        expect(order.status).to eq(Wegift::Response::STATUS[:error])
        expect(order.error_string).to eq('Field has invalid value')
        expect(order.order_id).to eq(nil)
      end
    end

    it 'should create a code' do
      client = set_wegift_client

      VCR.use_cassette('get_product_catalogue_valid') do
        product = client.products[1]

        VCR.use_cassette('post_order_valid') do
          order = client.order(
              :product_code => product.code,
              :currency_code => product.currency_code,
              :amount => 10,
              :external_ref => Time.now.to_i.to_s, # optional
              #:delivery_method => 'direct', # default
              #:delivery_format => 'raw', # default
          )

          expect(order.class).to eq(Wegift::Order)
          expect(order.is_successful?).to eq(true)
          expect(order.status).to eq(Wegift::Response::STATUS[:success])
          expect(order.error_string).to eq(nil)
          expect(order.amount).to eq(10)

          expect(order.code).not_to eq(nil)
          expect(order.order_id).not_to eq(nil)
          #expect(order.pin).not_to eq(nil)
          expect(order.expiry_date).not_to eq(nil)
        end

      end

    end

    it 'should create an url' do
      client = set_wegift_client

      VCR.use_cassette('get_product_catalogue_valid') do
        product = client.products[1]

        VCR.use_cassette('post_order_for_url_valid') do
          order = client.order(
              :product_code => product.code,
              :currency_code => product.currency_code,
              :amount => 10,
              :external_ref => Time.now.to_i.to_s, # optional
              #:delivery_method => 'direct', # default
              :delivery_format => 'url-instant',
          )

          expect(order.class).to eq(Wegift::Order)
          expect(order.is_successful?).to eq(true)
          expect(order.status).to eq(Wegift::Response::STATUS[:success])
          expect(order.error_string).to eq(nil)
          expect(order.amount).to eq(10)
          expect(order.delivery_url).not_to eq(nil)
          expect(order.order_id).not_to eq(nil)
        end

      end

    end

    # TODO: more checks/cases
  end

end