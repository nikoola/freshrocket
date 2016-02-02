require 'rspec_api_documentation/dsl'
require 'rspec_api_documentation'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.curl_host = 'http://localhost:3000'
  config.api_name = "Hi"
end

