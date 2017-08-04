# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler'
Bundler.require(:default, :test)

require 'webmock/rspec'

WebMock.enable!
WebMock.disable_net_connect!

Dir["./spec/support/**/*.rb"].each { |f| require f }

CloudPayments.configure do |c|
  c.public_key = 'user'
  c.secret_key = 'pass'
  c.host = 'http://localhost:9292'
  c.log = false
  # c.raise_banking_errors = true
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.include CloudPayments::RSpec::Helpers
end
