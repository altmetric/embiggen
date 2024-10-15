require 'embiggen'

module Embiggen
  RSpec.describe Configuration do
    describe '#timeout' do
      it 'defaults to 1 second' do
        expect(described_class.timeout).to eq(1)
      end

      it 'can be overridden' do
        described_class.timeout = 10

        expect(described_class.timeout).to eq(10)
      end

      after do
        described_class.timeout = 1
      end
    end

    describe '#redirects' do
      it 'defaults to 5' do
        expect(described_class.redirects).to eq(5)
      end

      it 'can be overridden' do
        described_class.redirects = 2

        expect(described_class.redirects).to eq(2)
      end

      after do
        described_class.redirects = 5
      end
    end

    describe '#shorteners' do
      it 'defaults to a list of shorteners' do
        expect(described_class.shorteners).to_not be_empty
      end

      it 'can be overridden' do
        expect { described_class.shorteners << 'foo.bar' }
          .to change { described_class.shorteners.size }.by(1)
      end

      after do
        described_class.shorteners.delete('foo.bar')
      end
    end
  end
end
