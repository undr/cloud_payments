$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

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

  config.after(:suite){ WebMock.allow_net_connect! }
end
