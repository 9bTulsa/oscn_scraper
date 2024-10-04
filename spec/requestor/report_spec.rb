require 'spec_helper'

RSpec.describe OscnScraper::Requestor::Report do
  describe '#fetch_daily_filings' do
    it 'only allows valid params' do
      params = {
        county: 'Oklahoma',
        bad_param: Date.new(2020, 1, 1)
      }
      expect { described_class.new(params).fetch_daily_filings }.to raise_error OscnScraper::Errors::InvalidParam
    end

    it 'only allows valid counties' do
      params = {
        county: 'Wagoner'
      }
      expect { described_class.new(params).fetch_daily_filings }.to raise_error OscnScraper::Errors::InvalidParam
    end

    it 'checks for required params' do
      params = {
        county: 'Oklahoma'
      }
      expect { described_class.new(params).fetch_daily_filings }.to raise_error OscnScraper::Errors::RequiredParam
    end
  end

  describe '#events_scheduled' do
    it 'only allows valid params' do
      params = {
        county: 'Oklahoma',
        bad_param: Date.new(2020, 1, 1)
      }
      expect { described_class.new(params).events_scheduled }.to raise_error OscnScraper::Errors::InvalidParam
    end

    it 'checks for required params' do
      params = {
        county: 'Oklahoma',
        case_type_id: 'CF-2021-21'
      }
      expect { described_class.new(params).events_scheduled }.to raise_error OscnScraper::Errors::RequiredParam
    end
  end
end
