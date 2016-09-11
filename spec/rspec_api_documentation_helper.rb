require 'rspec_api_documentation/dsl'
require 'rspec_api_documentation'

ENV['DOC_FORMAT'] ||= 'json'
RspecApiDocumentation.configure do |config|
  config.format = ENV['DOC_FORMAT']
  config.curl_host = 'http://localhost:3000'
  config.api_name = "Hi"
end



