# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Wegift::Product do
  describe 'GET' do
    describe 'all' do
      let(:code) { 'ARGOS-GB' }
      let(:client) { set_wegift_client }
      let(:product) { client.product(code) }
      let(:products) { client.products }

      context 'when unauthenticated' do
        let(:client) { set_wegift_client_unauthed }

        it 'should return an error' do
          VCR.use_cassette('get_product_catalogue_invalid_401') do
            expect(products.class).to eq(Wegift::Products)
            expect(products.status).to eq(Wegift::Response::STATUS[:error])
          end
        end
      end

      it 'should return a set of products' do
        VCR.use_cassette('get_product_catalogue_valid') do
          expect(products.class).to eq(Wegift::Products)
          expect(products.all.is_a?(Array)).to eq(true)
          expect(products.all.first.class).to eq(Wegift::Product)
          expect(products.status).to eq(Wegift::Response::STATUS[:success])
        end
      end

      it 'should return a single product' do
        VCR.use_cassette('get_product_catalogue_valid') do
          products = client.products.all
          product_from_catalog = products.first

          VCR.use_cassette('get_product_item_valid') do
            product = client.product(product_from_catalog.code)

            expect(product.class).to eq(Wegift::Product)
            expect(product.code).to eq(product_from_catalog.code)
          end
        end
      end

      it 'should have instructions' do
        VCR.use_cassette('get_product_item_valid_with_instructions') do
          expect(product.class).to eq(Wegift::Product)
          expect(product.code).to eq(code)
          expect(product.redeem_instructions_html).not_to eq(nil)
        end
      end

      it 'should have usage type' do
        VCR.use_cassette('get_product_item_valid_url_only') do
          # this should exist, can be null, "url-only/url-recommended" (ARGOS-GB / DECA-BE)
          expect(product.e_code_usage_type).to eq('url-only')
        end
      end

      it 'should have countries' do
        VCR.use_cassette('get_product_item_valid_url_only') do
          expect(product.countries).to eq(["GB"])
        end
      end

      it 'should have categories' do
        VCR.use_cassette('get_product_item_valid_url_only') do
          expect(product.categories).to include('entertainment')
        end
      end

      it 'should have a state' do
        VCR.use_cassette('get_product_item_valid_url_only') do
          expect(product.state).to eq('LIVE')
        end
      end

      context 'realtime availability' do
        context 'fixed denomination type' do
          let(:code) { '800PET-US' }

          it 'should have available denominations' do
            VCR.use_cassette('get_product_item_realtime_fixed') do
              expect(product.available_denominations).to match_array(['25.00', '50.00'])
            end
          end
        end

        context 'open denomination type' do
          it 'should not have available denominations' do
            VCR.use_cassette('get_product_item_valid_url_only') do
              expect(product.available_denominations).to be_nil
            end
          end
        end
      end
    end
  end
end
