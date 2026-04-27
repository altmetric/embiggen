# encoding: utf-8
require 'embiggen/html_client'

module Embiggen
  RSpec.describe HtmlClient do
    describe '#follow' do
      let(:uri) { URI('https://lnkd.in/eB25Z2yS') }
      let(:client) { described_class.new(uri) }

      it 'returns the href from the matched element' do
        stub_request(:get, 'https://lnkd.in/eB25Z2yS')
          .to_return(
            status: 200,
            body: '<html><body><main><a href="https://example.com/article">https://example.com/article</a></main></body></html>',
            headers: { 'Content-Type' => 'text/html' }
          )

        expect(client.follow(1, 'main a')).to eq('https://example.com/article')
      end

      it 'returns nil when the response is not 200 OK' do
        stub_request(:get, 'https://lnkd.in/eB25Z2yS').to_return(status: 302, headers: { 'Location' => 'https://example.com' })

        expect(client.follow(1, 'main a')).to be_nil
      end

      it 'returns nil when no element matches the selector' do
        stub_request(:get, 'https://lnkd.in/eB25Z2yS')
          .to_return(status: 200, body: '<html><body><p>No link here</p></body></html>')

        expect(client.follow(1, 'main a')).to be_nil
      end

      it 'raises a network error if the URI times out' do
        stub_request(:get, 'https://lnkd.in/eB25Z2yS').to_timeout

        expect { client.follow(1, 'main a') }.to raise_error(NetworkError)
      end

      it 'raises a network error if the connection resets' do
        stub_request(:get, 'https://lnkd.in/eB25Z2yS').to_raise(::Errno::ECONNRESET)

        expect { client.follow(1, 'main a') }.to raise_error(NetworkError)
      end
    end
  end
end
