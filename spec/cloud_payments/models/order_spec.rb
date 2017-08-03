#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Order do
  subject{ described_class.new(attributes) }

  let(:attributes) do
    {
      id: 'f2K8LV6reGE9WBFn',
      number: 61,
      amount: 10.0,
      currency: 'RUB',
      currency_code: 0,
      email: 'client@test.local',
      description: 'Оплата на сайте example.com',
      require_confirmation: true,
      url:'https://orders.cloudpayments.ru/d/f2K8LV6reGE9WBFn'
    }
  end

  describe 'properties' do
    specify{ expect(subject.id).to eq('f2K8LV6reGE9WBFn') }
    specify{ expect(subject.number).to eq(61) }
    specify{ expect(subject.amount).to eq(10.0) }
    specify{ expect(subject.currency).to eq('RUB') }
    specify{ expect(subject.currency_code).to eq(0) }
    specify{ expect(subject.email).to eq('client@test.local') }
    specify{ expect(subject.description).to eq('Оплата на сайте example.com') }
    specify{ expect(subject.require_confirmation).to eq(true) }
    specify{ expect(subject.url).to eq('https://orders.cloudpayments.ru/d/f2K8LV6reGE9WBFn') }

    it_behaves_like :raise_without_attribute, :id
    it_behaves_like :raise_without_attribute, :number
    it_behaves_like :raise_without_attribute, :amount
    it_behaves_like :raise_without_attribute, :currency
    it_behaves_like :raise_without_attribute, :currency_code
    it_behaves_like :raise_without_attribute, :description
    it_behaves_like :raise_without_attribute, :require_confirmation
    it_behaves_like :raise_without_attribute, :url

    it_behaves_like :not_raise_without_attribute, :email
  end

  describe 'transformations' do
    context 'amount from string' do
      before { attributes[:amount] = '293.42' }
      specify{ expect(subject.amount).to eql(293.42) }
    end

    context 'require_confirmation from "1"' do
      before { attributes[:require_confirmation] = '1' }
      specify{ expect(subject.require_confirmation).to eql(true) }
    end

    context 'require_confirmation from "0"' do
      before { attributes[:require_confirmation] = '0' }
      specify{ expect(subject.require_confirmation).to eql(false) }
    end
  end
end
