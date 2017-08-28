# frozen_string_literal: true
require 'date'
require 'hashie'
require 'faraday'
require 'multi_json'
require 'cloud_payments/version'
require 'cloud_payments/config'
require 'cloud_payments/namespaces'
require 'cloud_payments/models'
require 'cloud_payments/client'
require 'cloud_payments/webhooks'

module CloudPayments
  extend self

  def config=(value)
    @config = value
  end

  def config
    @config ||= Config.new
  end

  def configure
    yield config
  end

  def client=(value)
    @client = value
  end

  def client
    @client ||= Client.new
  end

  def webhooks
    @webhooks ||= Webhooks.new
  end
end
