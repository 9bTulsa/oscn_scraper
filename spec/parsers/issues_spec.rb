# rubocop:disable Metrics/BlockLength
RSpec.describe OscnScraper::Parsers::Issues do
  describe '#parse' do
    context 'when case has a single issue' do
      it 'parses the data' do
        fixture_path = 'spec/fixtures/parsers/issues/one-party.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html).css('body').children
        data = described_class.parse(parsed_html)

        expect(data[:issues].count).to eq 1
        expect(data[:issues].first[:issue_name]).to eq 'FORCIBLE ENTRY & DETAINER <$5000.00.'
        expect(data[:issues].first[:issue_code]).to eq 'SCFED1'
        expect(data[:issues].first[:parties].count).to eq 1
        expect(data[:issues].first[:parties].first[:verdict]).to eq 'DISMISSED'
      end
    end

    context 'when case has a simplified issue format' do
      it 'parses the data' do
        fixture_path = 'spec/fixtures/parsers/issues/simplified-format.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html).css('body').children
        data = described_class.parse(parsed_html)

        expect(data[:issues].count).to eq 1
        expect(data[:issues].first[:number]).to eq '1'
        expect(data[:issues].first[:issue_name]).to eq 'FORCIBLE ENTRY AND DETAINER/SMALL CLAIMS UP TO $5,000.00'
      end
    end

    context 'when case has two parties' do
      it 'parses the data' do
        fixture_path = 'spec/fixtures/parsers/issues/two-party.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html).css('body').children
        data = described_class.parse(parsed_html)

        expect(data[:issues].count).to eq 1
        expect(data[:issues].first[:issue_name]).to eq 'FORCIBLE ENTRY & DETAINER <$5000.00.'
        expect(data[:issues].first[:issue_code]).to eq 'SCFED1'
        expect(data[:issues].first[:parties].count).to eq 2
        expect(data[:issues].first[:parties].first[:verdict]).to eq 'DEFAULT JUDGEMENT'
      end
    end

    context 'when case has three parties' do
      it 'parses the data' do
        fixture_path = 'spec/fixtures/parsers/issues/three-party.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html).css('body').children
        data = described_class.parse(parsed_html)

        expect(data[:issues].count).to eq 1
        expect(data[:issues].first[:issue_name]).to eq 'FORCIBLE ENTRY & DETAINER <$5000.00.'
        expect(data[:issues].first[:issue_code]).to eq 'SCFED1'
        expect(data[:issues].first[:parties].count).to eq 3
        expect(data[:issues].first[:parties].first[:verdict]).to eq 'DEFAULT JUDGEMENT'
      end
    end

    context 'when case has not yet been disposed' do
      it 'parses the data' do
        fixture_path = 'spec/fixtures/parsers/issues/no-disposition.html'
        html_doc = load_and_parse_fixture(fixture_path)
        parsed_html = html_doc.css('body').children
        data = described_class.parse(parsed_html)

        expect(data[:issues].count).to eq 1
        expect(data[:issues].first[:parties].count).to eq 0
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
