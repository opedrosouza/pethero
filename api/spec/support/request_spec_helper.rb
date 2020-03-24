require 'devise/jwt/test_helpers'

module RequestSpecHelper
  def json_body
      @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end

  def auth_headers user
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end