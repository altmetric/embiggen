require 'embiggen'

module Embiggen
  RSpec.describe EmbiggenedURI do
    describe '.success' do
      it 'returns successful URIs' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri).to be_success
      end
    end

    describe '.failure' do
      it 'returns unsuccessful URIs' do
        failed_uri = described_class.failure(URI('http://bit.ly/bad'))

        expect(failed_uri).to_not be_success
      end

      it 'takes an optional reason for failure' do
        uri = URI.new('http://bit.ly/bad')
        failed_uri = described_class.failure(uri, 'something went wrong')

        expect(failed_uri.reason).to eq('something went wrong')
      end
    end

    describe '#uri' do
      it 'returns the URI within' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.uri).to eq(URI('http://www.altmetric.com'))
      end
    end

    describe '#inspect' do
      it 'reports the correct class name' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.inspect).to eq('#<Embiggen::EmbiggenedURI ' \
                                  'http://www.altmetric.com>')
      end
    end

    describe '#to_s' do
      it 'returns the URI as a string' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.to_s).to eq('http://www.altmetric.com')
      end
    end

    describe '#host' do
      it 'returns the host of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.host).to eq('www.altmetric.com')
      end
    end

    describe '#port' do
      it 'returns the port of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.port).to eq(80)
      end
    end

    describe '#path' do
      it 'returns the path of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com/foo?123'))

        expect(uri.path).to eq('/foo')
      end
    end

    describe '#scheme' do
      it 'returns the scheme of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com'))

        expect(uri.scheme).to eq('http')
      end
    end

    describe '#request_uri' do
      it 'returns the request URI of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com/foo?123'))

        expect(uri.request_uri).to eq('/foo?123')
      end
    end

    describe '#fragment' do
      it 'returns the fragment of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com/#foo'))

        expect(uri.fragment).to eq('foo')
      end
    end

    describe '#query' do
      it 'returns the query string of the URI' do
        uri = described_class.success(URI('http://www.altmetric.com?foo=123'))

        expect(uri.query).to eq('foo=123')
      end
    end
  end
end
