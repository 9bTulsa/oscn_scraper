module OscnScraper
  # Description/Explanation of Docket Events
  module Parsers
    # Description/Explanation of Docket Events
    class DocketEvents
      include Helpers

      attr_reader :docket_events_html

      def initialize(docket_events_html)
        @docket_events_html = docket_events_html
        @docket_events = { docket_events: [] }
      end

      def self.parse(docket_events_html)
        new(docket_events_html).parse
      end

      def parse
        parse_docket_events
      end

      private

      attr_accessor :docket_events

      def parse_docket_events
        return docket_events if docket_events_html.blank?

        last_date = false
        docket_events_html.css('tbody tr').each_with_index do |row, i|
          last_date = date(row.css('td')[0]).present? ? date(row.css('td')[0]) : last_date
          docket_events[:docket_events] << {
            event_number: i,
            date: last_date,
            code: sanitize_data(row.css('td')[1]),
            description: sanitize_data(row.css('td')[2]),
            count: sanitize_data(row.css('td')[3]),
            party: sanitize_data(row.css('td')[4]),
            amount: sanitize_data(row.css('td')[5]),
            links: parse_links(row)
          }
        end
        docket_events
      end

      def parse_links(row)
        row.css('a').map { |link| { title: link.text, link: "https://www.oscn.net/dockets/#{link['href']}", oscn_id: extract_id(link['href']) } }
      end

      def extract_id(link_url)
        url = URI.parse(link_url)
        params = CGI.parse(url.query)
        params['bc'].first
      end

      def date(data)
        return nil if sanitize_data(data) == ''
        begin
          Date.strptime(sanitize_data(data), '%m-%d-%Y')
        rescue Date::Error
          Date.strptime(sanitize_data(data), '%m/%d/%Y')
        end
      end
    end
  end
end
