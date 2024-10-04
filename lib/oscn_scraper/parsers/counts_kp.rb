module OscnScraper
  module Parsers
    # Description/Explanation of Case class
    class CountsKp
      include OscnScraper::Parsers::Helpers
      attr_reader :counts_html

      def initialize(counts_html)
        @counts_html = counts_html
        @counts = { counts: [] }
      end

      def self.parse(counts_html)
        new(counts_html).parse
      end

      def parse
        parse_counts
      end

      private

      attr_accessor :counts

      def parse_counts
        return counts if counts_html.count < 1

        counts_html.each do |row|
          parties_html(row).each do |p|
            counts[:counts] << count_object(row, p)
          end
        end
        counts
      end

      def count_object(row, party)
        {
          number: count_number(row),
          party_name: party_name(party),
          offense_on: offense_on(row),
          as_filed: as_filed(row),
          filed_statute_code: filed_code(row),
          filed_statute_violation: statute(row),
          filed_statute_violation_link: statute_link(row),
          disposition: disposition(party),
          charge: charge(party),
          disposition_on: disposition_on(party),
          disposed_statute_code: disposition_code(party),
          disposed_statute_violation: disposition_statute(party),
          disposed_statute_violation_link: disposition_link(party),
          plea: disposition_plea(party),
          verdict: disposition_verdict(party)
        }
      end

      def count_number(row)
        row.css('td')[0].text.gsub('Count # ', '').gsub('.', '')&.squish
      end

      def disposition(party_html)
        party_html.css('td font[color="red"]').text.squish.gsub('Disposed: ', '')
      end

      def charge(party_html)
        data = party_html.css('td')[2]&.children
        data[3]&.text&.gsub('Count as Disposed:', '')&.squish
      end

      def disposition_on(party_html)
        data = disposition(party_html).match(/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/).to_s
        parse_date(data)
      end

      def disposition_link(party_html)
        party_html.css('td a').attribute('href')&.text&.squish
      end

      def disposition_statute(party_html)
        party_html.css('td a')&.text&.squish
      end

      def disposition_code(party_html)
        data = party_html.css('td')[2]&.children
        full = data[3]&.text&.gsub('Count as Disposed:', '')&.squish
        full.rpartition('(')[2]&.gsub(')', '') if full.present?
      end

      def party_name(party_html)
        party_html.css('td')[1].text
      end

      def disposition_plea(party_html)
        disposition(party_html).split('.')[1]&.squish
      end

      def disposition_verdict(party_html)
        disposition(party_html).split(',')[0]&.squish
      end

      def filed_html(row)
        row.at('td:contains("Count as Filed:")')
      end

      def as_filed(row)
        filed_html(row).children[0].text.squish.split(',')[1]&.squish
      end

      def filed_code(row)
        filed_html(row).children[0].text.squish.split(',')[0].gsub('Count as Filed: ', '')&.squish
      end

      def statute(row)
        filed_html(row).children[1].text
      end

      def statute_link(row)
        filed_html(row).children[1].attribute('href')&.value&.squish
      end

      def offense_on(row)
        data = filed_html(row).children[3].text.gsub('Date of Offense: ', '')
        parse_date(data)
      end

      def parties_html(row)
        row.at('table:contains("Party Name")').css('tbody tr')
      end
    end
  end
end
