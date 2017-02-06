# frozen_string_literal: true
require 'languagedaily_parser/common'
require 'languagedaily_parser/http_client'

module LanguagedailyParser
  class PageList
    include LanguagedailyParser::Common

    attr_accessor :url, :base_url, :page

    def initialize(url)
      http_client = LanguagedailyParser::HttpClient.new(url)
      response = http_client.get
      self.url = http_client.url
      self.base_url = http_client.base_url
      self.page = Nokogiri::HTML(response)
    end

    def page_links
      if @page_links.blank?
        @page_links = [self.url]
        html_node(self.page, '.jsn-article-content ul li a',
                  get_all: true).each do |node|
          relative_link = node['href']
          if relative_link.present?
            link = "#{self.base_url}#{relative_link}"
            @page_links << link
          end
        end
        @page_links
      end
    end
  end
end
