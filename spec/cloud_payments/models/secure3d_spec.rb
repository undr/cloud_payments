# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments::Secure3D do
  describe 'properties' do
    let(:attributes){ {
      transaction_id: 504,
      pa_req: 'pa_req',
      acs_url: 'acs_url'
    } }

    subject{ CloudPayments::Secure3D.new(attributes) }

    specify{ expect(subject.transaction_id).to eq(504) }
    specify{ expect(subject.pa_req).to eq('pa_req') }
    specify{ expect(subject.acs_url).to eq('acs_url') }

    context 'without any attributes' do
      let(:attributes){ {} }
      specify{ expect{ subject }.to raise_error(/\'transaction_id\' is required/) }
    end

    context 'without `transaction_id` attribute' do
      let(:attributes){ { pa_req: 'pa_req', acs_url: 'acs_url' } }
      specify{ expect{ subject }.to raise_error(/\'transaction_id\' is required/) }
    end

    context 'without `pa_req` attribute' do
      let(:attributes){ { transaction_id: 504, acs_url: 'acs_url' } }
      specify{ expect{ subject }.to raise_error(/\'pa_req\' is required/) }
    end

    context 'without `acs_url` attribute' do
      let(:attributes){ { transaction_id: 504, pa_req: 'pa_req' } }
      specify{ expect{ subject }.to raise_error(/\'acs_url\' is required/) }
    end
  end
end
