# frozen_string_literal: true

module YcScraper
  class CompanyListService < BaseService
    def fetch_companies(filters, limit = 10, offset = 0)
      query_string = build_query_string(filters)
      parsed_page = fetch_page("#{BASE_URL}/companies?#{query_string}")
      companies = []

      parsed_page.css('._section_86jzd_146 ._company_86jzd_338').drop(offset).each do |company_card|
        break if companies.size >= limit

        company = {
          'Company Name' => company_card.css('._coName_86jzd_453').text.strip,
          'Short Description' => company_card.css('._coDescription_86jzd_478').text.strip,
          'Company Location' => company_card.css('._coLocation_86jzd_469').text.strip,
          'YC Batch' => company_card.css('._tagLink_86jzd_1023:nth-child(1)').text.strip
        }

        company.merge!(CompanyDetailsService.new.fetch_details(company_card.attribute_nodes[1].value))

        companies << company
      end

      companies
    end

    private

    def build_query_string(filters)
      filters.map { |key, value| "#{key}=#{value}" }.join('&')
    end
  end
end
