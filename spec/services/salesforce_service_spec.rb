require 'rails_helper'

RSpec.describe SalesforceService, type: :service do
  before do
    @service = described_class.new
  end

  describe 'Restforce Client' do
    before do
      @client = @service.client
    end

    it 'is not nil', focus: false do
      expect(@client).not_to be_nil
    end

    it 'can authenticate' do
      expect { @client.authenticate! }.not_to raise_error
    end

    it 'can execute a query to list users', focus: false do
      expect(@service.list_users.count).to be > 0
    end

    it 'can execute a query to list accounts', focus: false do
      res = @service.list_accounts
      puts res.first
      expect(res.count).to be > 0
    end

    it 'can find an account by Id', focus: false do
      id = '001ak00000W8ZRDAA3'
      name = 'Sample Account for Entitlements'
      res = @service.find_account(id:)
      expect(res['Id']).to eq(id)
      expect(res['Name']).to eq(name)
    end

    it 'can find an account by Name', focus: false do
      id = '001ak00000W8ZRDAA3'
      name = 'Sample Account for Entitlements'
      res = @service.find_account(name:).first
      expect(res['Id']).to eq(id)
      expect(res['Name']).to eq(name)
    end

    it 'can create and delete an account', focus: false do
      name = Faker::Company.name
      id = @service.create_account(name:)
      expect(id.length).to eq(18)
      res = @service.find_account(id:)
      expect(res['Id']).to eq(id)
      expect(res['Name']).to eq(name)
      @service.delete_account(id:)
      expect { @service.find_account(id:) }.to raise_error(Restforce::NotFoundError)
    end
  end

  describe 'Access Token' do
    before do
      @access_token = @service.request_access_token
    end

    it 'is 112 characters long' do
      puts @access_token
      expect(@access_token.length).to eq(112)
    end

    it 'matches a broad alphanumeric pattern' do
      expect(valid_token?(@access_token)).to be true
    end
  end

  def valid_token?(token)
    has_lowercase = token.match?(/[a-z]/)
    has_uppercase = token.match?(/[A-Z]/)
    has_number = token.match?(/\d/)
    has_special = token.match?(/[!@#$%^&*(),.?":{}|<>]/)

    has_lowercase && has_uppercase && has_number && has_special
  end
end
