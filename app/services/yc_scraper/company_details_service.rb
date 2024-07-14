# frozen_string_literal: true

module YcScraper
  class CompanyDetailsService < BaseService
    def fetch_details(link)
      # Complete the URL if necessary
      full_link = link.start_with?('http') ? link : "#{BASE_URL}#{link}"
      parsed_page = fetch_page(full_link)

      {
        'Website' => fetch_website(parsed_page),
        'All founder names' => fetch_founders(parsed_page),
        'LinkedIn URLs of founders' => fetch_linkedin_urls(parsed_page)
      }
    end

    private

    def fetch_website(parsed_page)
      website_element = parsed_page.at_css('.group.flex-row.items-center').children.last.attribute_nodes[0].value
      website_element ? website_element.strip : ''
    end

    def fetch_founders(parsed_page)
      parsed_page.css('.leading-snug .font-bold').map { |founder| founder.text.strip }
    end

    def fetch_linkedin_urls(parsed_page)
      parsed_page.css('.leading-snug .bg-image-linkedin').map { |a| a['href'] }.compact
    end
  end
end
