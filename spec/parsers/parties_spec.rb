RSpec.describe OscnScraper::Parsers::Parties do
  it 'parses the parties' do
    fixture_path = 'spec/fixtures/parsers/parties/multiple.html'
    parsed_html = load_and_parse_fixture(fixture_path)
    data = described_class.parse(parsed_html)

    expect(data[:parties].count).to eq 2
    expect(data[:parties].first[:link]).to eq 'GetPartyRecord.aspx?db=oklahoma&cn=CF-2024-3682&id=19656360'
    expect(data[:parties].first[:party_type]).to eq 'Defendant'
  end

  it 'parses the parties when there are no links' do
    fixture_path = 'spec/fixtures/parsers/parties/no-link.html'
    parsed_html = load_and_parse_fixture(fixture_path)
    data = described_class.parse(parsed_html)

    expect(data[:parties].count).to eq 2
    expect(data[:parties].first[:name]).to eq('Cavalry SPV I, LLC')
    expect(data[:parties].first[:party_type]).to eq('Plaintiff')
    expect(data[:parties].last[:name]).to eq('Paul,  John  O')
    expect(data[:parties].last[:party_type]).to eq('Defendant')
  end
end
