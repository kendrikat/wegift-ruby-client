require 'spec_helper'
require 'wegift/models/order'

RSpec.describe Wegift::Order do

  def set_order(product_code, delivery, amount, currency_code, external_ref)
    Wegift::Order.new(
        :product_code => product_code,
        :delivery => delivery,
        :amount => amount,
        :currency_code => currency_code,
        :external_ref => external_ref
    )
  end

  it 'should set payload' do
    order = set_order('1', 'direct', '3', '4', '5')
    expect(order.product_code).to eq('1')
    expect(order.delivery).to eq('direct')
    expect(order.amount).to eq('3')
    expect(order.currency_code).to eq('4')
    expect(order.external_ref).to eq('5')
  end

  describe 'POST' do

    it 'should return error (404)' do
      client = set_wegift_client
      order = set_order('NOPE', '2', '3', '4', '5')

      VCR.use_cassette('post_order_invalid_404') do
        order.post(client)

        expect(order.is_successful?).to eq(false)
        expect(order.status).to eq(Wegift::Response::STATUS[:error])
        expect(order.error_string).to eq('Field has invalid value')
      end
    end

    it 'should return error (401)' do
      client = set_wegift_client
      order = set_order('tTV', Wegift::Order::DELIVERY_TYPE[:direct], '0', 'GBP', nil)

      VCR.use_cassette('post_order_invalid_401') do
        order.post(client)

        expect(order.is_successful?).to eq(false)
        expect(order.status).to eq(Wegift::Response::STATUS[:error])
        expect(order.error_string).to eq('Field has invalid value')
      end
    end

    it 'should create a code' do
      client = set_wegift_client
      order = set_order('tTV', Wegift::Order::DELIVERY_TYPE[:direct], '1', 'GBP', nil)

      VCR.use_cassette('post_order_valid') do
        order.post(client)

        expect(order.is_successful?).to eq(true)
        expect(order.status).to eq(Wegift::Response::STATUS[:success])
        expect(order.error_string).to eq(nil)
        expect(order.amount).to eq('1')

        expect(order.code).not_to eq(nil)
        expect(order.pin).not_to eq(nil)
        expect(order.expiry_date).not_to eq(nil)
      end
    end

    # TODO: more checks/cases
  end

end