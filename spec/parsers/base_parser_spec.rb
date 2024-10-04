# rubocop:disable Metrics/BlockLength

RSpec.describe OscnScraper::Parsers::BaseParser do
  describe '#build_object' do
    context 'when parsing a criminal case' do
      it 'parses html' do
        fixture_path = 'spec/fixtures/example.html'
        parsed_html = load_and_parse_fixture(fixture_path)
        data = described_class.new(parsed_html).build_object

        expect(data[:events].count).to eq 6
        expect(data[:attorneys].count).to eq 1
        expect(data[:parties].count).to eq 3
        expect(data[:counts].count).to eq 2
        expect(data[:docket_events].count).to eq 47
      end
    end

    context 'when parsing a small claims case' do
      it 'parses the html' do
        fixture_path = 'spec/fixtures/small-claims-example.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html)
        data = described_class.new(parsed_html).build_object

        expect(data[:events].count).to eq 1
        expect(data[:attorneys].count).to eq 1
        expect(data[:parties].count).to eq 2
        expect(data[:counts].count).to eq 0
        expect(data[:issues].count).to eq 1
        expect(data[:docket_events].count).to eq 19
      end
    end

    context 'when parsing a kp case for a smaller county (vs an ocis case) ' do
      it 'parses the html' do
        fixture_path = 'spec/fixtures/kp-example.html'
        html = File.read(fixture_path) # Custom parse to fix nokogiri parse error
        html = html.gsub('<$', '< $')
        parsed_html = Nokogiri::HTML.parse(html)
        data = described_class.new(parsed_html).build_object

        expect(data[:events].count).to_not be nil
        expect(data[:attorneys].count).to_not be nil
        expect(data[:parties].count).to_not be nil
        expect(data[:counts].count).to_not be nil
        expect(data[:issues].count).to_not be nil
        expect(data[:docket_events].count).to_not be nil
      end
    end

    context 'when the case is not found on OSCN' do
      it 'returns a helpful message' do
        fixture_path = 'spec/fixtures/case_not_found.html'
        html = File.read(fixture_path)
        parsed_html = Nokogiri::HTML.parse(html)
        data = described_class.new(parsed_html).build_object

        expect(data).to eq OscnScraper::Errors::CaseNotFound
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
