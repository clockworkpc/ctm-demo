require 'restforce'
require 'uri'
require 'net/http'

class SalesforceService
  attr_reader :access_token

  def initialize
    @access_token = get_access_token
  end

  def get_access_token
    my_domain = Rails.application.credentials[:sf_instance_url_dev]
    url = URI("#{my_domain}/services/oauth2/token")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    client_id = Rails.application.credentials[:sf_consumer_key]
    client_secret = Rails.application.credentials[:sf_consumer_secret]
    request.body = "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}"
    response = https.request(request)
    JSON.parse(response.body)['access_token']
  rescue StandardError => e
    Rails.logger.info(e)
  end

  def list_accounts
    @client.query('SELECT Id, Name FROM Account')
  end
end

#   def get_access_token_from_cli
#     output = `sf org display --target-org dev`
#   end
# end

# url = URI("https://garbersquaredllc-dev-ed.develop.my.salesforce.com/services/data/v61.0")
#
# https = Net::HTTP.new(url.host, url.port)
# https.use_ssl = true
#
# request = Net::HTTP::Get.new(url)
# request["Authorization"] = "Bearer 00Dak00000CC78T\\!AQEAQKI0QEntEDjlcezm62fCub7GaTwNeffUDswJZ6JXkKxJKJwOpZ1JVRYv90yDm89asA2ADUflEZzF2EvNYB.f1IwvDvbc"
#
# response = https.request(request)
# puts response.read_body
#
# #   def initialize
# #     # @client = Rails.application.config.salesforce_client
# #     @client = Restforce.new(
# #       username: Rails.application.credentials[:sf_username],
# #       password: Rails.application.credentials[:sf_password],
# #       instance_url: Rails.application.credentials[:sf_instance_url],
# #       host: Rails.application.credentials[:sf_host],
# #       client_id: Rails.application.credentials[:sf_consumer_key],
# #       client_secret: Rails.application.credentials[:sf_consumer_secret],
# #       api_version: '61.0'
# #     )
# #   end
# #
# #   def find_account(account_id)
# #     @client.find('Account', account_id)
# #   end
# #
# #   def create_contact(contact_params)
# #     @client.create('Contact', contact_params)
# #   end
# #
# #   # Add more methods to interact with Salesforce as needed
# # end
