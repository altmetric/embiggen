require 'embiggen/non_redirect_shortener_list'

RSpec.describe Embiggen::NonRedirectShortenerList do
  describe '#supported?' do
    it 'returns true for a URI whose host is in the list' do
      list = described_class.new('lnkd.in' => 'main a')

      expect(list.supported?(URI('https://lnkd.in/eB25Z2yS'))).to be(true)
    end

    it 'returns false for a URI whose host is not in the list' do
      list = described_class.new('lnkd.in' => 'main a')

      expect(list.supported?(URI('https://example.com/foo'))).to be(false)
    end
  end

  describe '#selector_for' do
    it 'returns the selector for a matching URI' do
      list = described_class.new('lnkd.in' => 'main a')

      expect(list.selector_for(URI('https://lnkd.in/eB25Z2yS'))).to eq('main a')
    end

    it 'returns nil for a non-matching URI' do
      list = described_class.new('lnkd.in' => 'main a')

      expect(list.selector_for(URI('https://example.com/foo'))).to be_nil
    end

    it 'returns nil if the URI only matches due to an unescaped dot' do
      list = described_class.new('lnkd.in' => 'main a')

      expect(list.selector_for(URI('https://lnkdXin/foo'))).to be_nil
    end
  end

  describe '#clear' do
    it 'removes all entries' do
      list = described_class.new('lnkd.in' => 'main a')
      list.clear

      expect(list.size).to eq(0)
    end
  end
end
