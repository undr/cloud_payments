RSpec.shared_examples :not_raise_without_attribute do |key, method = nil|
  method = key unless method

  context "without `#{key}` attribute" do
    subject do
      attrs = attributes.dup
      attrs.delete(key)
      described_class.new(attrs)
    end

    specify{ expect{ subject }.not_to raise_error }
  end
end

RSpec.shared_examples :raise_without_attribute do |key, method = nil|
  method = key unless method

  context "without `#{key}` attribute" do
    subject do
      attrs = attributes.dup
      attrs.delete(key)
      described_class.new(attrs)
    end

    specify{ expect{ subject }.to raise_error(/\'#{method}\' is required/) }
  end
end
