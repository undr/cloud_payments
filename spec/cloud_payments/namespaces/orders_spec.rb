#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Namespaces::Orders do
  subject{ described_class.new(CloudPayments.client) }

  describe '#create' do
    let(:attributes) do
      {
        amount:               10.0,
        currency:             'RUB',
        description:          'Оплата на сайте example.com',
        email:                'client@test.local',
        require_confirmation: true,
        send_email:           false,
        invoice_id:           'invoice_100',
        account_id:           'account_200',
        phone:                '+7(495)765-4321',
        send_sms:             false,
        send_whats_app:       false
      }
    end

    context do
      before{ stub_api_request('orders/create/successful').perform }

      specify{ expect(subject.create(attributes)).to be_instance_of(CloudPayments::Order) }

      context do
        let(:sub){ subject.create(attributes) }

        specify{ expect(sub.id).to eq('f2K8LV6reGE9WBFn') }
        specify{ expect(sub.amount).to eq(10.0) }
        specify{ expect(sub.currency).to eq('RUB') }
        specify{ expect(sub.currency_code).to eq(0) }
        specify{ expect(sub.email).to eq('client@test.local') }
        specify{ expect(sub.description).to eq('Оплата на сайте example.com') }
        specify{ expect(sub.require_confirmation).to eq(true) }
        specify{ expect(sub.url).to eq('https://orders.cloudpayments.ru/d/f2K8LV6reGE9WBFn') }
      end
    end
  end

  describe '#cancel' do
    context do
      before{ stub_api_request('orders/cancel/successful').perform }
      specify{ expect(subject.cancel('12345')).to be_truthy }
    end

    context do
      before{ stub_api_request('orders/cancel/failed').perform }
      specify{ expect{ subject.cancel('12345') }.to raise_error(CloudPayments::Client::GatewayError, 'Error message') }
    end
  end
end
