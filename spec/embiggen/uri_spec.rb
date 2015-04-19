require 'embiggen'

module Embiggen
  RSpec.describe URI do
    describe '#expand' do
      it 'expands HTTP URIs' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://us.macmillan.com/books/9781466879980')

        uri = described_class.new(URI('http://bit.ly/1ciyUPh'))

        expect(uri.expand).to embiggen_to(URI('http://us.macmillan.com/books/9781466879980'))
      end

      it 'marks expanded URIs as successful' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://us.macmillan.com/books/9781466879980')

        uri = described_class.new(URI('http://bit.ly/1ciyUPh'))

        expect(uri.expand).to be_success
      end

      it 'expands HTTPS URIs' do
        stub_redirect('https://youtu.be/dQw4w9WgXcQ',
                      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be')

        uri = described_class.new(URI('https://youtu.be/dQw4w9WgXcQ'))

        expect(uri.expand).to embiggen_to(URI('https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'))
      end

      it 'expands URIs passed as strings' do
        stub_redirect('http://bit.ly/1ciyUPh',
                      'http://us.macmillan.com/books/9781466879980')

        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri.expand).to embiggen_to(URI('http://us.macmillan.com/books/9781466879980'))
      end

      it 'does not expand unshortened URIs' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect(uri.expand).to embiggen_to(URI('http://www.altmetric.com'))
      end

      it 'does not make requests for unshortened URIs' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect { uri.expand }.to_not raise_error
      end

      it 'does not expand erroring URIs' do
        stub_request(:head, 'http://bit.ly/bad').to_return(:status => 500)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to embiggen_to(URI('http://bit.ly/bad'))
      end

      it 'marks erroring URIs as unsuccessful' do
        stub_request(:head, 'http://bit.ly/bad').to_return(:status => 500)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to_not be_success
      end

      it 'does not expand URIs that time out' do
        stub_request(:head, 'http://bit.ly/bad').to_timeout
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to embiggen_to(URI('http://bit.ly/bad'))
      end

      it 'marks timed out URIs as unsuccessful' do
        stub_request(:head, 'http://bit.ly/bad').to_timeout
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to_not be_success
      end

      it 'does not expand URIs whose connection resets' do
        stub_request(:head, 'http://bit.ly/bad').to_raise(Errno::ECONNRESET)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to embiggen_to(URI('http://bit.ly/bad'))
      end

      it 'marks URIs whose connection resets as unsuccessful' do
        stub_request(:head, 'http://bit.ly/bad').to_raise(Errno::ECONNRESET)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand).to_not be_success
      end

      it 'takes an optional timeout' do
        stub_request(:head, 'http://bit.ly/bad').to_timeout
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect(uri.expand(:timeout => 5)).to embiggen_to(URI('http://bit.ly/bad'))
      end

      it 'expands redirects to other shorteners' do
        stub_redirect('http://bit.ly/98K8eH',
                      'https://youtu.be/dQw4w9WgXcQ')
        stub_redirect('https://youtu.be/dQw4w9WgXcQ',
                      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be')
        uri = described_class.new(URI('http://bit.ly/98K8eH'))

        expect(uri.expand).to embiggen_to(URI('https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'))
      end

      it 'stops expanding redirects after a default threshold of 5' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        stub_redirect('http://bit.ly/4', 'http://bit.ly/5')
        stub_redirect('http://bit.ly/5', 'http://bit.ly/6')
        stub_redirect('http://bit.ly/6', 'http://bit.ly/7')
        uri = described_class.new(URI('http://bit.ly/1'))

        expect(uri.expand).to embiggen_to(URI('http://bit.ly/6'))
      end

      it 'takes an optional redirect threshold' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new(URI('http://bit.ly/1'))

        expect(uri.expand(:redirects => 2)).to embiggen_to(URI('http://bit.ly/3'))
      end

      it 'uses the threshold from the configuration' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new(URI('http://bit.ly/1'))
        Configuration.redirects = 2

        expect(uri.expand).to embiggen_to(URI('http://bit.ly/3'))
      end

      it 'uses shorteners from the configuration' do
        stub_redirect('http://altmetric.it', 'http://www.altmetric.com')
        Configuration.shorteners << 'altmetric.it'
        uri = described_class.new(URI('http://altmetric.it'))

        expect(uri.expand).to embiggen_to(URI('http://www.altmetric.com'))
      end

      after do
        Configuration.redirects = 5
        Configuration.shorteners.delete('altmetric.it')
      end
    end

    describe '#expand!' do
      around { |example| silence_warnings(example) }

      it 'expands shortened URLs' do
        stub_redirect('https://youtu.be/dQw4w9WgXcQ',
                      'https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be')
        uri = described_class.new(URI('https://youtu.be/dQw4w9WgXcQ'))

        expect(uri.expand!).to embiggen_to(URI('https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be'))
      end

      it 'does not expand unshortened URIs' do
        uri = described_class.new(URI('http://www.altmetric.com'))

        expect(uri.expand!).to embiggen_to(URI('http://www.altmetric.com'))
      end

      it 'raises an error if the URI redirects too many times' do
        stub_redirect('http://bit.ly/1', 'http://bit.ly/2')
        stub_redirect('http://bit.ly/2', 'http://bit.ly/3')
        stub_redirect('http://bit.ly/3', 'http://bit.ly/4')
        uri = described_class.new(URI('http://bit.ly/1'))

        expect { uri.expand!(:redirects => 2) }.
          to raise_error(TooManyRedirects)
      end

      it 'raises an error if a shortened URI does not redirect' do
        stub_request(:head, 'http://bit.ly/bad').to_return(:status => 500)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect { uri.expand! }.to raise_error(BadShortenedURI)
      end

      it 'raises an error if the URI times out' do
        stub_request(:head, 'http://bit.ly/bad').to_timeout
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect { uri.expand! }.to raise_error(::Timeout::Error)
      end

      it 'raises an error if the URI errors' do
        stub_request(:head, 'http://bit.ly/bad').to_raise(::Errno::ECONNRESET)
        uri = described_class.new(URI('http://bit.ly/bad'))

        expect { uri.expand! }.to raise_error(::Errno::ECONNRESET)
      end
    end

    describe '#uri' do
      it 'returns the original URI' do
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

    describe '#expanded?' do
      it 'is true if the link is not shortened' do
        uri = described_class.new('http://www.altmetric.com')

        expect(uri).to be_expanded
      end

      it 'is false if the link is shortened' do
        uri = described_class.new('http://bit.ly/1ciyUPh')

        expect(uri).to_not be_expanded
      end
    end

    describe '#inspect' do
      it 'reports the correct class name' do
        uri = described_class.new('http://www.altmetric.com')

        expect(uri.inspect).to eq('#<Embiggen::URI http://www.altmetric.com>')
      end
    end

    def stub_redirect(short_url, expanded_url, status = 301)
      stub_request(:head, short_url).
        to_return(:status => status, :headers => { 'Location' => expanded_url })
    end

    def silence_warnings(example)
      original_verbose, $VERBOSE = $VERBOSE, nil
      example.run
    ensure
      $VERBOSE = original_verbose
    end
  end
end
