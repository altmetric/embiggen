require 'embiggen/shortener_list'

RSpec.describe Embiggen::ShortenerList do
  describe '#new' do
    it 'can be given a set' do
      list = described_class.new(Set['a.com', 'b.com', 'b.com'])

      expect(list.size).to eq(2)
    end

    it 'converts a given enumerable to a set' do
      list = described_class.new(%w(a.com a.com))

      expect(list.size).to eq(1)
    end
  end

  describe '#include?' do
    it 'returns true if a URL host is on the whitelist' do
      list = described_class.new(%w(bit.ly))

      expect(list).to include(URI('http://bit.ly/foo'))
    end

    it 'returns false if a URL host is not on the whitelist' do
      list = described_class.new(%w(bit.ly))

      expect(list).to_not include(URI('http://www.altmetric.com'))
    end
  end

  describe '#<<' do
    it 'appends domains to the list' do
      list = described_class.new([])
      list << 'bit.ly'

      expect(list).to include(URI('http://bit.ly/foo'))
    end

    it 'can be chained' do
      list = described_class.new([])
      list << 'bit.ly' << 'a.com'

      expect(list).to include(URI('http://bit.ly/foo'), URI('http://a.com/bar'))
    end
  end

  describe '#size' do
    it 'returns the number of domains in the list' do
      list = described_class.new(%w(bit.ly ow.ly))

      expect(list.size).to eq(2)
    end
  end

  describe '#delete' do
    it 'removes domains from the list' do
      list = described_class.new(%w(bit.ly))
      list.delete('bit.ly')

      expect(list).to be_empty
    end
  end

  describe '#+' do
    it 'appends a list of domains to the existing one' do
      list = described_class.new(%w(bit.ly))
      list += %w(a.com)

      expect(list).to include(URI('http://a.com/foo'))
    end

    it 'can combine two lists' do
      list = described_class.new(%w(bit.ly))
      list += described_class.new(%w(a.com))

      expect(list).to include(URI('http://a.com/foo'))
    end
  end

  it 'is enumerable for 1.8 compatiblity' do
    list = described_class.new([])

    expect(list).to be_kind_of(Enumerable)
  end
end
