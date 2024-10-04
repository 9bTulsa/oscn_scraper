# rubocop:disable Metrics/BlockLength
RSpec.describe OscnScraper::Parsers::Counts do
  describe '#parse' do
    it 'parses a case with multiple counts' do
      fixture_path = 'spec/fixtures/parsers/counts/multiple.html'
      html_doc = load_and_parse_fixture(fixture_path)
      parsed_html = html_doc.css('.CountsContainer')
      data = described_class.parse(parsed_html)

      expect(data[:counts].count).to eq 2
      expect(data[:counts].first[:number]).to eq '1'
      expect(data[:counts][1][:number]).to eq '2'
      expect(data[:counts].first[:disposition]).to eq 'CONVICTION, 07/02/2018. Guilty Plea'
    end

    it 'parses a single count' do
      fixture_path = 'spec/fixtures/parsers/counts/single.html'
      html_doc = load_and_parse_fixture(fixture_path)
      parsed_html = html_doc.css('.CountsContainer')
      data = described_class.parse(parsed_html)

      expect(data[:counts].count).to eq 1
      expect(data[:counts].first[:disposition]).to eq 'CONVICTION, 01/14/2020. Guilty Plea'
      expect(data[:counts].first[:filed_statute_code]).to eq 'BRG2'
    end

    it 'parses a count for a kp case' do
      fixture_path = 'spec/fixtures/parsers/counts/kp_small_counties.html'
      html_doc = load_and_parse_fixture(fixture_path)
      parsed_html = html_doc.css('.CountsContainer')
      data = described_class.parse(parsed_html)

      expect(data[:counts].count).to eq 1
      expect(data[:counts].first[:disposition]).to eq 'CONVICTION, 01/14/2020. Guilty Plea'
      expect(data[:counts].first[:filed_statute_code]).to eq 'BRG2'
    end

    it 'parses a counts without disposition info' do
      fixture_path = 'spec/fixtures/parsers/counts/no_disposition_info.html'
      html_doc = load_and_parse_fixture(fixture_path)
      parsed_html = html_doc.css('.CountsContainer')
      data = described_class.parse(parsed_html)

      expect(data[:counts].count).to eq 3
      expect(data[:counts].first[:as_filed]).to eq 'DRIVING WHILE UNDER THE INFLUENCE'
    end

    it 'parses the last parentheses from the Count as Disposed text' do
      fixture_path = 'spec/fixtures/parsers/counts/multiple_parentheses_count.html'
      html_doc = load_and_parse_fixture(fixture_path)
      parsed_html = html_doc.css('.CountsContainer')
      data = described_class.parse(parsed_html)

      expect(data[:counts].count).to eq 4
      expect(data[:counts].first[:disposed_statute_code]).to eq 'DU2II'
    end
  end
end
# rubocop:enable Metrics/BlockLength
