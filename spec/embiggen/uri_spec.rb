# encoding: utf-8
require 'embiggen'

module Embiggen
  RSpec.describe URI do
    describe '#expand' do
      it 'expands HTTP URIs' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://us.macmillan.com/books/9781466879980')

        uri = described_class.new(URI('http://bit.ly/1ciyUPh'))

        expect(uri.expand).to eq(URI('http://us.macmillan.com/books/9781466879980'))
      end

      it 'expands HTTPS URIs' do
        stub_redirect('https://youtu.be/dQw4w9WgXcQ',
                      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be')

        uri = described_class.new(URI('https://youtu.be/dQw4w9WgXcQ'))

        expect(uri.expand).to eq(URI('https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'))
      end

      it 'expands URIs passed as strings' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://us.macmillan.com/books/9781466879980')

        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri.expand).to eq(URI('http://us.macmillan.com/books/9781466879980'))
      end

      it 'expands URIs with encoded locations' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://www.example.com/%C3%A9%20%C3%BC')

        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri.expand).to eq(URI('http://www.example.com/%C3%A9%20%C3%BC'))
      end

      it 'expands URIs with unencoded locations' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://www.example.com/é ü')

        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri.expand).to eq(URI('http://www.example.com/%C3%A9%20%C3%BC'))
      end

      it 'does not expand unshortened URIs' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect(uri.expand).to eq(URI('http://www.altmetric.com'))
      end

      it 'does not make requests for unshortened URIs' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect { uri.expand }.to_not raise_error
      end

      it 'raises an error if the URI redirects too many times' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new('http://bit.ly/1')

        expect { uri.expand(:redirects => 2) }.
          to raise_error(TooManyRedirects)
      end

      it 'retains the last URI when redirecting too many times' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new('http://bit.ly/1')

        last_uri = nil

        begin
          uri.expand(:redirects => 2)
        rescue TooManyRedirects => ex
          last_uri = ex.uri
        end

        expect(last_uri).to eq(URI('http://bit.ly/3'))
      end

      it 'raises an error if a shortened URI does not redirect' do
        stub_request(:head, 'http://bit.ly/bad').to_return(:status => 500)
        uri = described_class.new('http://bit.ly/bad')

        expect { uri.expand }.to raise_error(BadShortenedURI)
      end

      it 'raises and error if the URI returned is not valid' do
        stub_redirect('http://bit.ly/suspicious', '|cat /etc/passwd')
        uri = described_class.new('http://bit.ly/suspicious')

        expect { uri.expand }.to raise_error(BadShortenedURI)
      end

      it 'retains the last URI if a shortened URI does not redirect' do
        stub_redirect('http://bit.ly/bad', 'http://bit.ly/bad2')
        stub_request(:head, 'http://bit.ly/bad2').to_return(:status => 500)
        uri = described_class.new('http://bit.ly/bad')

        last_uri = nil

        begin
          uri.expand
        rescue BadShortenedURI => ex
          last_uri = ex.uri
        end

        expect(last_uri).to eq(URI('http://bit.ly/bad2'))
      end

      it 'raises a network error if the URI times out' do
        stub_request(:head, 'http://bit.ly/bad').to_timeout
        uri = described_class.new('http://bit.ly/bad')

        expect { uri.expand }.to raise_error(NetworkError)
      end

      it 'raises a network error if the connection resets' do
        stub_request(:head, 'http://bit.ly/bad').to_raise(::Errno::ECONNRESET)
        uri = described_class.new('http://bit.ly/bad')

        expect { uri.expand }.to raise_error(NetworkError)
      end

      it 'raises a network error if the host cannot be reached' do
        stub_request(:head, 'http://bit.ly/bad').to_raise(::Errno::EHOSTUNREACH)
        uri = described_class.new('http://bit.ly/bad')

        expect { uri.expand }.to raise_error(NetworkError)
      end

      it 'retains the last URI if there is a network error' do
        stub_redirect('http://bit.ly/bad', 'http://bit.ly/bad2')
        stub_request(:head, 'http://bit.ly/bad2').to_timeout
        uri = described_class.new('http://bit.ly/bad')

        begin
          uri.expand
        rescue NetworkError => ex
          last_uri = ex.uri
        end

        expect(last_uri).to eq(URI('http://bit.ly/bad2'))
      end

      it 'expands redirects to other shorteners' do
        stub_redirect('http://bit.ly/98K8eH',
                      'https://youtu.be/dQw4w9WgXcQ')
        stub_redirect('https://youtu.be/dQw4w9WgXcQ',
                      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be')
        uri = described_class.new(URI('http://bit.ly/98K8eH'))

        expect(uri.expand).to eq(URI('https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'))
      end

      it 'stops expanding redirects after a default threshold of 5' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        stub_redirect('http://bit.ly/4', 'http://bit.ly/5')
        stub_redirect('http://bit.ly/5', 'http://bit.ly/6')
        stub_redirect('http://bit.ly/6', 'http://bit.ly/7')
        uri = described_class.new(URI('http://bit.ly/1'))

        expect { uri.expand }.to raise_error(TooManyRedirects)
      end

      it 'takes an optional redirect threshold' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new(URI('http://bit.ly/1'))

        expect { uri.expand(:redirects => 2) }.to raise_error(TooManyRedirects)
      end

      it 'uses the threshold from the configuration' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new(URI('http://bit.ly/1'))
        Configuration.redirects = 2

        expect { uri.expand }.to raise_error(TooManyRedirects)
      end

      it 'uses shorteners from the configuration' do
        stub_redirect('http://altmetric.it', 'http://www.altmetric.com')
        Configuration.shorteners << 'altmetric.it'
        uri = described_class.new(URI('http://altmetric.it'))

        expect(uri.expand).to eq(URI('http://www.altmetric.com'))
      end

      after do
        Configuration.redirects = 5
        Configuration.shorteners.delete('altmetric.it')
      end
    end

    describe '#uri' do
      it 'returns a URI' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect(uri.uri).to eq(URI('http://www.altmetric.com'))
      end

      it 'returns a URI even if a string was passed' do
        uri = described_class.new('http://www.altmetric.com')

        expect(uri.uri).to eq(URI('http://www.altmetric.com'))
      end
    end

    describe '#shortened?' do
      it 'returns true if the link has been shortened' do
        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri).to be_shortened
      end

      it 'returns false if the link has not been shortened' do
        uri = described_class.new('http://www.altmetric.com')

        expect(uri).to_not be_shortened
      end

      it 'returns true if the link has been shortened with the wrong case' do
        uri = described_class.new('http://BIT.LY/1ciyUPh')

        expect(uri).to be_shortened
      end

      it 'returns false if the link is not shortened but uses a similar ' \
         'domain' do
        uri = described_class.new('http://notbit.ly/1ciyUPh')

        expect(uri).to_not be_shortened
      end
    end

    describe '#http_client' do
      it 'returns the HTTP client for the given URI' do
        uri = described_class.new('http://www.altmetric.com')

        expect(uri.http_client.uri).to eq(URI('http://www.altmetric.com'))
      end
    end

    def stub_redirect(short_url, expanded_url, status = 301)
      stub_request(:head, short_url).
        to_return(:status => status, :headers => { 'Location' => expanded_url })
    end
  end
end
