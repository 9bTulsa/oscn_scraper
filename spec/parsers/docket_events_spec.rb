RSpec.describe OscnScraper::Parsers::DocketEvents do
  describe '#parse' do
    it 'parses a case with many docket events' do
      fixture_path = 'spec/fixtures/parsers/docket_events/multiple.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(false).to eq true
      # Test that all data is there
    end

    it 'parses another example case with many docket events' do
      fixture_path = 'spec/fixtures/parsers/docket_events/multiple.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(false).to eq true
      # Test that all data is there
    end
  end
end
