module OscnScraper
  module Requestor

    DAILING_FILINGS_COUNTIES = [
      'Adair', 'Canadian', 'Cleveland', 'Comanche',  'Ellis', 'Garfield', 'Logan', 'Oklahoma', 'Payne', 'Pushmataha',
      'Roger Mills', 'Rogers', 'Tulsa'
    ]
    # Searches reports on OSCN
    # @note OSCN Endpoint - https:://www.oscn.net/applications/oscn/report.asp?
    class Report < Base
      attr_reader :kwargs

      # Initialize the class
      #
      # @param [Hash] kwargs
      # @option kwargs [String] :db Name of Oklahoma County
      # @option kwargs [Date] :date Date for report
      # @option kwargs [CaseTypeID] :case_type_id OSCN ID for the case type
      # @return Request data
      def initialize(kwargs = {})
        super()
        @kwargs = kwargs
      end

      # Makes request to OSCN for the cases filed on a given date
      #
      # @param param_name [data_type]
      # @return Request response
      def fetch_daily_filings
        unless DAILING_FILINGS_COUNTIES.include? kwargs[:county]
          raise ::OscnScraper::Errors::InvalidParam, 'County not available for DailyFilings report'
        end
        valid_params?(kwargs.keys, valid_daily_filings_params)
        required_params?(kwargs.keys, required_daily_filing_params)
        params = {
          report: 'DailyFilings',
          errorcheck: true,
          db: kwargs[:county],
          StartDate: kwargs[:date]
        }
        request(concatenated_url(endpoint, params))
      end

      # Makes request to OSCN for cases that are in the docket for a given date and Case Type
      #
      # @param county [String]
      # @param case_type_id [Integer]
      # @param date [Date]
      # @return Request response
      def events_scheduled
        valid_params?(kwargs.keys, valid_events_params)
        required_params?(kwargs.keys, required_events_params)
        params = {
          errorcheck: true,
          db: kwargs[:county],
          CaseTypeID: kwargs[:case_type_id].to_s,
          StartDate: kwargs[:date],
          GeneralNumber: 1,
          generalnumber1: 1,
          report: 'WebJudicialDocketCaseTypeAll'
        }
        request(concatenated_url(endpoint, params))
      end

      private

      def endpoint
        'applications/oscn/report.asp?'
      end

      def valid_events_params
        %i[county case_type_id date]
      end

      def required_events_params
        valid_events_params
      end

      def valid_daily_filings_params
        %i[date county]
      end

      def required_daily_filing_params
        valid_daily_filings_params
      end
    end
  end
end
