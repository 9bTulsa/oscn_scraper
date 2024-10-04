module OscnScraper
  module Requestor
    # Searches for a specific party
    # @note OSCN Enpoint - https://www.oscn.net/dockets/GetPartyRecord.aspx?
    class Party < Base
      attr_reader :county, :oscn_id, :case_number

      # Initialize the class
      #
      # @param county [String] Name of Oklahoma County
      # @param oscn_id [Integer] OSCN id for the party
      # @param oscn_id [String] an OSCN case number for party (required for some small counties, e.g., Wagoner)
      def initialize(county, oscn_id, case_number)
        super()
        @county = county
        @oscn_id = oscn_id
        @case_number = case_number
      end

      # Class method to call fetch_party
      def self.fetch_party(county, oscn_id, case_number)
        new(county, oscn_id, case_number).fetch_party
      end

      # Makes request to OSCN
      #
      # @return Request data
      def fetch_party
        params = {
          db: county,
          id: oscn_id,
          cn: case_number
        }
        request(concatenated_url(endpoint, params))
      end

      private

      def endpoint
        'dockets/GetPartyRecord.aspx?'
      end
    end
  end
end
