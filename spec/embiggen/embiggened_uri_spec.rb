require 'embiggen'

module Embiggen
  RSpec.describe EmbiggenedURI do
    describe '.success' do
      it 'returns successful URIs' do
        uri = described_class.success(URI.new('http://www.altmetric.com'))

        expect(uri).to be_success
      end
    end

    describe '.failure' do
      it 'returns unsuccessful URIs' do
        failed_uri = described_class.failure(URI.new('http://bit.ly/bad'))

        expect(failed_uri).to_not be_success
      end

      it 'takes an optional reason for failure' do
        uri = URI.new('http://bit.ly/bad')
        failed_uri = described_class.failure(uri, 'something went wrong')

        expect(failed_uri.reason).to eq('something went wrong')
      end
    end

    describe '#inspect' do
      it 'reports the correct class name' do
        uri = described_class.success(URI.new('http://www.altmetric.com'))

        expect(uri.inspect).to eq('#<Embiggen::EmbiggenedURI ' \
                                  'http://www.altmetric.com>')
      end
    end
  end
end
