require 'spec_helper'

describe CloudPayments::Namespaces::Subscriptions do
  subject{ CloudPayments::Namespaces::Subscriptions.new(CloudPayments.client) }

  describe '#find' do
    context do
      before{ stub_api_request('subscriptions/get/successful').perform }

      specify{ expect(subject.find('sc_8cf8a9338fb')).to be_instance_of(CloudPayments::Subscription) }

      context do
        let(:sub){ subject.find('sc_8cf8a9338fb') }

        specify{ expect(sub.id).to eq('sc_8cf8a9338fb') }
        specify{ expect(sub.account_id).to eq('user@example.com') }
        specify{ expect(sub.description).to eq('Monthly subscription') }
        specify{ expect(sub.started_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
        specify{ expect(sub).to be_active }
      end
    end
  end

  describe '#find_all', :focus do
    context do
      before{ stub_api_request('subscriptions/find/successful').perform }

      specify{ expect(subject.find_all("user@example.com")).to be_instance_of(Array) }
      specify{ expect(subject.find_all("user@example.com").first).to be_instance_of(CloudPayments::Subscription) }

      context do
        let(:sub){ subject.find_all("user@example.com").first }

        specify{ expect(sub.id).to eq('sc_8cf8a9338fb') }
        specify{ expect(sub.account_id).to eq('user@example.com') }
        specify{ expect(sub.description).to eq('Monthly subscription') }
        specify{ expect(sub.started_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
        specify{ expect(sub).to be_active }
      end
    end
  end

  describe '#create' do
    let(:attributes){ {
      token: '477BBA133C182267F',
      account_id: 'user@example.com',
      description: 'Monthly subscription',
      email: 'user@example.com',
      amount: 1.02,
      currency: 'RUB',
      require_confirmation: false,
      start_date: '2014-08-09T11:49:41',
      interval: 'Month',
      period: 1,
      max_periods: 12
    } }

    context do
      before{ stub_api_request('subscriptions/create/successful').perform }

      specify{ expect(subject.create(attributes)).to be_instance_of(CloudPayments::Subscription) }

      context do
        let(:sub){ subject.create(attributes) }

        specify{ expect(sub.id).to eq('sc_8cf8a9338fb') }
        specify{ expect(sub.account_id).to eq('user@example.com') }
        specify{ expect(sub.description).to eq('Monthly subscription') }
        specify{ expect(sub.started_at).to eq(DateTime.parse('2014-08-09T11:49:41')) }
        specify{ expect(sub).to be_active }
      end
    end
  end

  describe '#update' do
    let(:attributes){ { account_id: 'user2@example.com', email: 'user2@example.com', max_periods: 6 } }

    context do
      before{ stub_api_request('subscriptions/update/successful').perform }

      specify{ expect(subject.update('sc_8cf8a9338fb', attributes)).to be_instance_of(CloudPayments::Subscription) }

      context do
        let(:sub){ subject.update('sc_8cf8a9338fb', attributes) }

        specify{ expect(sub.id).to eq('sc_8cf8a9338fb') }
        specify{ expect(sub.account_id).to eq('user2@example.com') }
        specify{ expect(sub.max_periods).to eq(6) }
        specify{ expect(sub).to be_active }
      end
    end
  end

  describe '#cancel' do
    context do
      before{ stub_api_request('subscriptions/cancel/successful').perform }

      specify{ expect(subject.cancel('sc_8cf8a9338fb')).to be_truthy }
    end
  end
end
