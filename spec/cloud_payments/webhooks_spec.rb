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
end
