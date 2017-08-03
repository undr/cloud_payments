# frozen_string_literal: true
require 'spec_helper'

describe CloudPayments do
  describe '#config=' do
    before{ @old_config = CloudPayments.config }
    after{ CloudPayments.config = @old_config }

    specify{ expect{ CloudPayments.config = 'config' }.to change{ CloudPayments.config }.to('config') }
  end

  describe '#config' do
    specify{ expect(CloudPayments.config).to be_instance_of(CloudPayments::Config) }
  end
end
