RSpec.describe OscnScraper::Parsers::DocketEvents do
  describe '#parse' do
    it 'parses a case with many docket events' do
      fixture_path = 'spec/fixtures/parsers/docket_events/multiple.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(data[:docket_events].count).to eq 136
    end

    it 'parses another example case with many docket events' do
      fixture_path = 'spec/fixtures/parsers/docket_events/additional.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(data[:docket_events].count).to eq 224
    end

    it 'parses docket events with alternative dates' do
      fixture_path = 'spec/fixtures/parsers/docket_events/alt-date-format.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(data[:docket_events].count).not_to be nil
    end

    it 'parses docket events with multiple rows for the same date' do
      fixture_path = 'spec/fixtures/parsers/docket_events/multirow-for-date.html'
      parsed_html = load_and_parse_fixture(fixture_path)
      data = described_class.parse(parsed_html)

      expect(data[:docket_events][1][:date]).to eq data[:docket_events][0][:date]
      expect(data[:docket_events].last[:date]).not_to eq data[:docket_events][0][:date]
    end

    context 'when a link is in the docket event' do
      it 'returns the links array' do
        fixture_path = 'spec/fixtures/parsers/docket_events/with_link.html'
        parsed_html = load_and_parse_fixture(fixture_path)
        data = described_class.parse(parsed_html)
        event_with_links = data[:docket_events].find { |de| de[:event_number] == 6 }
        expected_keys = %i[title link oscn_id]

        expect(event_with_links[:links].count).to eq 2
        expect(event_with_links[:links].first.keys - expected_keys).to eq []
        first_link = event_with_links[:links].first
        expect(first_link[:oscn_id]).to eq '1048798689'
        expect(first_link[:title]).to eq 'TIFF'
      end
    end
  end
end
