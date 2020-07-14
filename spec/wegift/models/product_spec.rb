# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Wegift::Product do
  describe 'GET' do
    describe 'all' do
      it 'should return error if unauthed' do
        client = set_wegift_client_unauthed

        VCR.use_cassette('get_product_catalogue_invalid_401') do
          products = client.products

          expect(products.class).to eq(Wegift::Products)
          expect(products.status).to eq(Wegift::Response::STATUS[:error])
        end
      end

      it 'should return a set of products' do
        client = set_wegift_client

        VCR.use_cassette('get_product_catalogue_valid') do
          products = client.products

          expect(products.class).to eq(Wegift::Products)
          expect(products.all.is_a?(Array)).to eq(true)
          expect(products.all.first.class).to eq(Wegift::Product)
          expect(products.status).to eq(Wegift::Response::STATUS[:success])
        end
      end

      it 'should return a single product' do
        client = set_wegift_client

        VCR.use_cassette('get_product_catalogue_valid') do
          products = client.products.all
          p = products.first

          VCR.use_cassette('get_product_item_valid') do
            product = client.product(p.code)

            expect(product.class).to eq(Wegift::Product)
            expect(product.code).to eq(p.code)
          end
        end
      end

      it 'should have instructions' do
        client = set_wegift_client
        VCR.use_cassette('get_product_item_valid_with_instructions') do
          # picked manually since it could be nil for others
          code = 'ARGOS-GB'
          product = client.product(code)

          expect(product.class).to eq(Wegift::Product)
          expect(product.code).to eq(code)
          expect(product.redeem_instructions_html).not_to eq(nil)
          # ...
        end
      end

      it 'should have usage type' do
        client = set_wegift_client
        VCR.use_cassette('get_product_item_valid_url_only') do
          code = 'ARGOS-GB'
          product = client.product(code)

          # this should exist, can be null, "url-only/url-recommended" (ARGOS-GB / DECA-BE)
          expect(product.e_code_usage_type).to eq('url-only')
          # ...
        end
      end

      it 'should have countries' do
        client = set_wegift_client
        VCR.use_cassette('get_product_item_valid_url_only') do
          code = 'ARGOS-GB'
          product = client.product(code)

          expect(product.countries).to eq(["GB"])
          # ...
        end
      end

      it 'should have categories' do
        client = set_wegift_client
        VCR.use_cassette('get_product_item_valid_url_only') do
          code = 'ARGOS-GB'
          product = client.product(code)

          expect(product.categories).to include('entertainment')
          # ...
        end
      end
    end
  end
end
