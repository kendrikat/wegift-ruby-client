# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Wegift::Stock do
  describe 'GET' do
    let(:stock) { client.stock('BLUMEN-DE') }

    context 'not authenticated' do
      let(:client) { set_wegift_client_unauthed }

      it 'returns an error status' do
        VCR.use_cassette('get_stock_invalid_401') do
          expect(stock.status).to eq(Wegift::Response::STATUS[:error])
        end
      end

      it 'returns 401 error code' do
        VCR.use_cassette('get_stock_invalid_401') do
          expect(stock.error_code).to eq(401)
        end
      end
    end

    context 'authenticated' do
      let(:client) { set_wegift_client }

      it 'returns a success status' do
        VCR.use_cassette('get_stock_valid') do
          expect(stock.status).to eq(Wegift::Response::STATUS[:success])
        end
      end

      it 'returns the quantity for each denomination' do
        VCR.use_cassette('get_stock_valid') do
          expect(stock.payload['available_stock'].count).to_not eq(0)
        end
      end

      it 'returns the product code' do
        VCR.use_cassette('get_stock_valid') do
          expect(stock.payload['product_code']).to eq('BLUMEN-DE')
        end
      end

      it 'returns the product name' do
        VCR.use_cassette('get_stock_valid') do
          expect(stock.payload['product_name']).to eq('123 Blumenversand DE')
        end
      end

      it 'returns the currency code' do
        VCR.use_cassette('get_stock_valid') do
          expect(stock.payload['currency_code']).to eq('EUR')
        end
      end
    end
  end
end
