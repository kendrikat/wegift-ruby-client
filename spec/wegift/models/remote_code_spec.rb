# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Wegift::RemoteCode do
  describe 'GET' do
    let(:url) { 'https://playground.wegift.io/public/gifts/instant/c02bd09f-2c17-4bb6-ad5d-38f4143a01d0' }
    let(:remote_code) { client.remote_code(url) }
    let(:client) { set_wegift_client }

    it 'is successful' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.is_successful?).to be_truthy
      end
    end

    it 'returns the amount' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.amount).to eq('1.00')
      end
    end

    it 'returns the barcode format' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.barcode_format).to eq('code-128')
      end
    end

    it 'returns the barcode string' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.barcode_string).to eq('4919168309531457')
      end
    end

    it 'returns the code' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.code).to eq('4919168309531457')
      end
    end

    it 'returns the expiry date' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.expiry_date).to eq('2025-04-05')
      end
    end

    it 'returns the pin' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.pin).to eq('038572')
      end
    end

    it 'returns the type' do
      VCR.use_cassette('get_remote_code_valid') do
        expect(remote_code.type).to eq('code')
      end
    end
  end
end
