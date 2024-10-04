module OscnScraper
  module Parsers
    # Description/Explanation of Issues class
    class Issues
      include OscnScraper::Parsers::Helpers
      attr_reader :counts_html

      def initialize(issues_html)
        @issues_html = issues_html
        @issues = { issues: [] }
      end

      def self.parse(issues_html)
        new(issues_html).parse
      end

      def parse
        parse_issues
      end

      private

      attr_accessor :issues, :issues_html

      def parse_issues
        issue_content = issues_html.xpath('//*[preceding-sibling::h2[1][contains(@class, "issues")]]')
        issue_table = issue_content.css('table')[0]
        return parse_simplified_issues unless issue_table

        dispositions_table = issue_content.css('table')[1]
        issues[:issues] << issue_object(issue_table, dispositions_table)

        issues
      end

      def parse_simplified_issues
        # todo: add support for multiple issues once we can find example
        issue_paragraph = issues_html.xpath('//h2[contains(@class, "issues")]/following-sibling::p[1]')
        return issues if issue_paragraph.count < 1

        issues[:issues] << {
          number: issue_paragraph.css('strong')[0].text.gsub('.', ''),
          issue_name: issue_paragraph.xpath('./strong[1]/following-sibling::text()[1]').text.squish
        }
        issues
      end

      def issue_object(issue_table, dispositions_table)
        name_and_code = issue_table.css('tr td')[1].children[0].text.gsub('Issue:', '').squish.split('(')
        {
          number: issue_number(issue_table),
          issue_name: issue_name(name_and_code),
          issue_code: issue_code(name_and_code),
          filed_by: filed_by(issue_table),
          filed_on: filed_date(issue_table),
          parties: add_parties(dispositions_table)
        }
      end

      def add_parties(dispositions_table)
        parties = []
        dispositions_table.css('tbody tr').each do |row|
          return parties if party_name(row).blank?

          parties << disposition_object(row)
        end
        parties
      end

      def disposition_object(row)
        {
          name: party_name(row),
          disposition_on: disposition_on(row),
          verdict: verdict(row),
          verdict_detail: verdict_detail(row)
        }
      end

      def issue_number(table)
        table.css('tr td strong').text.split('#')[1].gsub('.', '').squish
      end

      def issue_name(name_and_code)
        name_and_code[0].squish
      end

      def issue_code(name_and_code)
        name_and_code[1].gsub(')', '').squish
      end

      def filed_by(table)
        table.css('tr td')[1].children[2].text.gsub('Filed By:', '').squish
      end

      def filed_date(table)
        table.css('tr td')[1].children[4].text.gsub('Filed Date:', '').squish
      end

      def disposition(row)
        row.css('td font[color="red"]').text.squish.gsub('Disposed: ', '')
      end

      def verdict(row)
        data = row.css('td')[2]&.children
        data.children.text.split(',').first&.gsub('Disposed:', '')&.squish
      end

      def verdict_detail(row)
        data = row.css('td')[2]&.children
        data.children.text.split('.')[1]&.squish
      end

      def disposition_on(row)
        data = disposition(row).match(/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/).to_s
        parse_date(data)
      end

      def party_name(row)
        row.css('td')[1].text.gsub('Defendant:', '').gsub('Plaintiff:', '').squish
      end
    end
  end
end
