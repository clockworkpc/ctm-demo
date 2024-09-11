require 'rails_helper'

RSpec.describe SalesforceService, type: :service do
  before do
    @service = described_class.new
    @client = @service.client
    @options = @client.options
  end

  describe 'Client Options' do
    it 'returns client api_version' do
      expect(@options[:api_version].to_i).to eq(61)
    end

    # it 'returns username' do
    #   expect(@options[:username]).to eq(Rails.application.credentials[:sf_username])
    # end
  end

  describe 'Basic Functions' do
    it '#list_accounts' do
      expect(@service.list_accounts).to eq('foo')
    end
  end
end
