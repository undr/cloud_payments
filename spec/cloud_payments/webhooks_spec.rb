#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Webhooks do
  describe 'HMAC validation' do
    let(:valid_hmac) { 'tJW02TMAce4Em8eJTNqjhOax+BYRM5K2D8mX9xsmUUc=' }
    let(:invalid_hmac) { '6sUXv4W0wmhfpkkDtp+3Hw/M8deAPkMRVV3OWANcqro=' }
    let(:data) {
      "TransactionId=666&Amount=123.00&Currency=RUB&PaymentAmount=123.00&PaymentCurrency=RUB&InvoiceId=1234567&AccountId=user%40example.com&SubscriptionId=&Name=VLADIMIR+KOCHNEV&Email=user%40example.com&DateTime=2015-11-17+14%3a51%3a20&IpAddress=127.0.0.1&IpCountry=RU&IpCity=%d0%a1%d0%b0%d0%bd%d0%ba%d1%82-%d0%9f%d0%b5%d1%82%d0%b5%d1%80%d0%b1%d1%83%d1%80%d0%b3&IpRegion=%d0%a1%d0%b0%d0%bd%d0%ba%d1%82-%d0%9f%d0%b5%d1%82%d0%b5%d1%80%d0%b1%d1%83%d1%80%d0%b3&IpDistrict=%d0%a1%d0%b5%d0%b2%d0%b5%d1%80%d0%be-%d0%97%d0%b0%d0%bf%d0%b0%d0%b4%d0%bd%d1%8b%d0%b9+%d1%84%d0%b5%d0%b4%d0%b5%d1%80%d0%b0%d0%bb%d1%8c%d0%bd%d1%8b%d0%b9+%d0%be%d0%ba%d1%80%d1%83%d0%b3&IpLatitude=59.939000&IpLongitude=30.315800&CardFirstSix=411111&CardLastFour=1111&CardType=Visa&CardExpDate=01%2f19&Issuer=&IssuerBankCountry=&Description=%d0%9e%d0%bf%d0%bb%d0%b0%d1%82%d0%b0+%d0%b2+example.com&AuthCode=DEADBEEF&Token=1234567890&TestMode=1&Status=Completed"
    }

    context 'with data_valid?' do
      it 'returns true on valid hmac' do
        expect(CloudPayments.webhooks.data_valid?(data, valid_hmac)).to be_truthy
      end

      it 'returns false on invalid hmac' do
        expect(CloudPayments.webhooks.data_valid?(data, invalid_hmac)).to be_falsey
      end
    end

    context 'with validate_data!' do
      it 'returns true on valid hmac' do
        expect(CloudPayments.webhooks.validate_data!(data, valid_hmac)).to be_truthy
      end

      it 'raises a HMACError on invalid hmac' do
        expect {
          CloudPayments.webhooks.validate_data!(data, invalid_hmac)
        }.to raise_error(CloudPayments::Webhooks::HMACError)
      end
    end
  end

  describe 'on_check' do
    let(:raw_data) do
      {"TransactionId"=>"1701609",
       "Amount"=>"123.00",
       "Currency"=>"RUB",
       "PaymentAmount"=>"123.00",
       "PaymentCurrency"=>"RUB",
       "InvoiceId"=>"1234567",
       "AccountId"=>"user@example.com",
       "SubscriptionId"=>"",
       "Name"=>"OLEG FOMIN",
       "Email"=>"user@example.com",
       "DateTime"=>"2015-11-17 23:06:15",
       "IpAddress"=>"127.0.0.1",
       "IpCountry"=>"RU",
       "IpCity"=>"Санкт-Петербург",
       "IpRegion"=>"Санкт-Петербург",
       "IpDistrict"=>"Северо-Западный федеральный округ",
       "IpLatitude"=>"59.939000",
       "IpLongitude"=>"30.315000",
       "CardFirstSix"=>"411111",
       "CardLastFour"=>"1111",
       "CardType"=>"Visa",
       "CardExpDate"=>"01/19",
       "Issuer"=>"",
       "IssuerBankCountry"=>"",
       "Description"=>"Оплата в example.com",
       "TestMode"=>"1",
       "Status"=>"Completed",
       "Data"=>
         "{\"cloudPayments\":{\"recurrent\":{\"interval\":\"Month\",\"period\":1}}}"}
    end

    subject { CloudPayments.webhooks.on_check(raw_data) }
  end

  describe 'on_pay' do
    let(:raw_data) do
      {"TransactionId"=>"1701609",
       "Amount"=>"123.00",
       "Currency"=>"RUB",
       "PaymentAmount"=>"123.00",
       "PaymentCurrency"=>"RUB",
       "InvoiceId"=>"1234567",
       "AccountId"=>"user@example.com",
       "SubscriptionId"=>"sc_b865df3d4f27c54dc8067520c071a",
       "Name"=>"OLEG FOMIN",
       "Email"=>"user@example.com",
       "DateTime"=>"2015-11-17 23:06:17",
       "IpAddress"=>"127.0.0.1",
       "IpCountry"=>"RU",
       "IpCity"=>"Санкт-Петербург",
       "IpRegion"=>"Санкт-Петербург",
       "IpDistrict"=>"Северо-Западный федеральный округ",
       "IpLatitude"=>"59.939037",
       "IpLongitude"=>"30.315784",
       "CardFirstSix"=>"411111",
       "CardLastFour"=>"1111",
       "CardType"=>"Visa",
       "CardExpDate"=>"01/19",
       "Issuer"=>"",
       "IssuerBankCountry"=>"",
       "Description"=>"Оплата в example.com",
       "AuthCode"=>"A1B2C3",
       "Token"=>"9BBEF19476623CA56C17DA75FD57734DBF82530686043A6E491C6D71BEFE8F6E",
       "TestMode"=>"1",
       "Status"=>"Completed",
       "Data"=>
         "{\"cloudPayments\":{\"recurrent\":{\"interval\":\"Month\",\"period\":1}}}"}
    end

    subject { CloudPayments.webhooks.on_pay(raw_data) }

    specify { expect(subject.id).to eq '1701609' }
    specify { expect(subject.amount).to eq 123.00 }
    specify { expect(subject.currency).to eq 'RUB' }
    specify { expect(subject.invoice_id).to eq '1234567' }
    specify { expect(subject.account_id).to eq 'user@example.com' }
    specify { expect(subject.subscription_id).to eq 'sc_b865df3d4f27c54dc8067520c071a' }
    specify { expect(subject.name).to eq 'OLEG FOMIN' }
    specify { expect(subject.email).to eq 'user@example.com' }
    specify { expect(subject.date_time).to eq DateTime.parse('2015-11-17 23:06:17') }
    specify { expect(subject.ip_address).to eq '127.0.0.1' }
    specify { expect(subject.ip_country).to eq 'RU' }
    specify { expect(subject.ip_city).to eq 'Санкт-Петербург' }
    specify { expect(subject.ip_region).to eq 'Санкт-Петербург' }
    specify { expect(subject.ip_district).to eq 'Северо-Западный федеральный округ' }
    specify { expect(subject.ip_lat).to eq '59.939037' }
    specify { expect(subject.ip_lng).to eq '30.315784' }
    specify { expect(subject.card_first_six).to eq '411111' }
    specify { expect(subject.card_last_four).to eq '1111' }
    specify { expect(subject.card_type).to eq 'Visa' }
    specify { expect(subject.card_exp_date).to eq '01/19' }
    specify { expect(subject.description).to eq 'Оплата в example.com' }
    specify { expect(subject.auth_code).to eq 'A1B2C3' }
    specify { expect(subject.token).to eq '9BBEF19476623CA56C17DA75FD57734DBF82530686043A6E491C6D71BEFE8F6E' }
    specify { expect(subject.status).to eq 'Completed' }
  end

  describe 'on_fail' do
    let(:raw_data) do
      {"TransactionId"=>"1701658",
       "Amount"=>"123.00",
       "Currency"=>"RUB",
       "PaymentAmount"=>"123.00",
       "PaymentCurrency"=>"RUB",
       "InvoiceId"=>"1234567",
       "AccountId"=>"user@example.com",
       "SubscriptionId"=>"",
       "Name"=>"OLEG FOMIN",
       "Email"=>"user@example.com",
       "DateTime"=>"2015-11-17 23:35:09",
       "IpAddress"=>"127.0.0.1",
       "IpCountry"=>"RU",
       "IpCity"=>"Санкт-Петербург",
       "IpRegion"=>"Санкт-Петербург",
       "IpDistrict"=>"Северо-Западный федеральный округ",
       "IpLatitude"=>"59.939037",
       "IpLongitude"=>"30.315784",
       "CardFirstSix"=>"400005",
       "CardLastFour"=>"5556",
       "CardType"=>"Visa",
       "CardExpDate"=>"01/19",
       "Issuer"=>"",
       "IssuerBankCountry"=>"",
       "Description"=>"Оплата в example.com",
       "TestMode"=>"1",
       "Status"=>"Declined",
       "StatusCode"=>"5",
       "Reason"=>"InsufficientFunds",
       "ReasonCode"=>"5051",
       "Data"=>
         "{\"cloudPayments\":{\"recurrent\":{\"interval\":\"Month\",\"period\":1}}}"}
    end

    subject { CloudPayments.webhooks.on_fail(raw_data) }

    specify { expect(subject.id).to eq '1701658' }
    specify { expect(subject.amount).to eq 123.00 }
    specify { expect(subject.currency).to eq 'RUB' }
    specify { expect(subject.invoice_id).to eq '1234567' }
    specify { expect(subject.account_id).to eq 'user@example.com' }
    specify { expect(subject.subscription_id).to eq '' }
    specify { expect(subject.name).to eq 'OLEG FOMIN' }
    specify { expect(subject.email).to eq 'user@example.com' }
    specify { expect(subject.date_time).to eq DateTime.parse('2015-11-17 23:35:09') }
    specify { expect(subject.ip_address).to eq '127.0.0.1' }
    specify { expect(subject.ip_country).to eq 'RU' }
    specify { expect(subject.ip_city).to eq 'Санкт-Петербург' }
    specify { expect(subject.ip_region).to eq 'Санкт-Петербург' }
    specify { expect(subject.ip_district).to eq 'Северо-Западный федеральный округ' }
    specify { expect(subject.card_first_six).to eq '400005' }
    specify { expect(subject.card_last_four).to eq '5556' }
    specify { expect(subject.card_type).to eq 'Visa' }
    specify { expect(subject.card_exp_date).to eq '01/19' }
    specify { expect(subject.description).to eq 'Оплата в example.com' }
  end

  describe 'on_recurrent' do
    let(:raw_data) do
      {"Id"=>"sc_a38ca02005d40db7d32b36a0097b0",
       "AccountId"=>"1234",
       "Description"=>"just description",
       "Email"=>"user@example.com",
       "Amount"=>"2.00",
       "Currency"=>"RUB",
       "RequireConfirmation"=>"0",
       "StartDate"=>"2015-12-17 20:22:14",
       "Interval"=>"Month",
       "Period"=>"1",
       "Status"=>"PastDue",
       "SuccessfulTransactionsNumber"=>"11",
       "FailedTransactionsNumber"=>"22",
       "NextTransactionDate"=>"2015-11-18 20:29:05"}
    end

    subject { CloudPayments.webhooks.on_recurrent(raw_data) }

    specify { expect(subject.id).to eq 'sc_a38ca02005d40db7d32b36a0097b0' }
    specify { expect(subject.account_id).to eq '1234' }
    specify { expect(subject.description).to eq 'just description' }
    specify { expect(subject.email).to eq 'user@example.com' }
    specify { expect(subject.amount).to eq 2.00 }
    specify { expect(subject.currency).to eq 'RUB' }
    specify { expect(subject.require_confirmation).to eq false }
    specify { expect(subject.started_at).to eq DateTime.parse('2015-12-17 20:22:14') }
    specify { expect(subject.interval).to eq 'Month' }
    specify { expect(subject.period).to eq 1 }
    specify { expect(subject.status).to eq 'PastDue' }
    specify { expect(subject.successful_transactions).to eq 11 }
    specify { expect(subject.failed_transactions).to eq 22 }
    specify { expect(subject.next_transaction_at).to eq DateTime.parse('2015-11-18 20:29:05') }
  end

  describe 'on_kassa_receipt' do
    let(:raw_data) do
      {"Id"=>"sc_a38ca02005d40db7d32b36a0097b0",
       "DocumentNumber"=>"1234",
       "SessionNumber"=>"12345",
       "FiscalSign"=>"signsgin",
       "DeviceNumber"=>"123465",
       "RegNumber"=>"12345",
       "Inn"=>"0",
       "Type"=>"Type",
       "Ofd"=>"Ofd",
       "Url"=>"http://example.com/url/",
       "QrCodeUrl"=>"http://example.com/url",
       "Amount"=>"11.11",
       "DateTime"=>"2015-11-18 20:29:05",
       "Receipt"=>"{}",
       "TransactionId" => "12321123",
       "InvoiceId" => "123123",
       "AccountId" => "3213213"}
    end

    subject { CloudPayments.webhooks.kassa_receipt(raw_data) }

    specify { expect(subject.id).to eq "sc_a38ca02005d40db7d32b36a0097b0" }
    specify { expect(subject.document_number).to eq '1234' }
    specify { expect(subject.session_number).to eq '12345' }
    specify { expect(subject.fiscal_sign).to eq 'signsgin' }
    specify { expect(subject.device_number).to eq '123465' }
    specify { expect(subject.reg_number).to eq '12345' }
    specify { expect(subject.inn).to eq '0' }
    specify { expect(subject.type).to eq 'Type' }
    specify { expect(subject.ofd).to eq 'Ofd' }
    specify { expect(subject.url).to eq 'http://example.com/url/' }
    specify { expect(subject.qr_code_url).to eq 'http://example.com/url' }
    specify { expect(subject.amount).to eq 11.11 }
    specify { expect(subject.date_time).to eq DateTime.parse('2015-11-18 20:29:05') }
    specify { expect(subject.receipt).to eq '{}' }
    specify { expect(subject.transaction_id).to eq '12321123' }
    specify { expect(subject.invoice_id).to eq '123123' }
    specify { expect(subject.account_id).to eq '3213213' }
  end
end
