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
end
