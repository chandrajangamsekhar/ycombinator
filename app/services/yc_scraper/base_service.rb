# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'

module YcScraper
  class BaseService
    BASE_URL = 'https://www.ycombinator.com'

    def initialize
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')
      @driver = Selenium::WebDriver.for :chrome, options: options
    end

    def fetch_page(url)
      @driver.navigate.to(url)
      sleep 2
      Nokogiri::HTML(@driver.page_source)
    ensure
      @driver.quit
    end
  end
end
