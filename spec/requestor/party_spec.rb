require 'spec_helper'

RSpec.describe OscnScraper::Requestor::Party do
  it 'gets the html' do
    request_url = 'https://www.oscn.net/dockets/GetPartyRecord.aspx?db=wagoner&cn=CF-2022-00029&id=6205953'
    response_body = 'test response'
    stub_request(:get, request_url)
      .to_return(status: 200, body: response_body, headers: {})
    result_response = described_class.fetch_party('wagoner', '6205953', 'CF-2022-00029')
    expect(result_response.body).to eq response_body
  end
end
