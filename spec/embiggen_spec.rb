require 'embiggen'

RSpec.describe Embiggen do
  describe '#URI' do
    it 'returns an Embiggen::URI' do
      uri = described_class::URI('http://www.altmetric.com')

      expect(uri).to be_a(described_class::URI)
    end

    it 'accepts an existing Embiggen::URI' do
      uri = described_class::URI.new('http://www.altmetric.com')

      expect(described_class::URI(uri)).to be_a(described_class::URI)
    end
  end

  describe '#configure' do
    it 'can be used to set global configuration' do
      described_class.configure do |config|
        config.timeout = 10
      end

      expect(described_class::Configuration.timeout).to eq(10)
    end

    after do
      described_class::Configuration.timeout = 1
    end
  end
end
