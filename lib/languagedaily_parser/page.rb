# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'languagedaily_parser/common'
require 'languagedaily_parser/http_client'

module LanguagedailyParser
  class Page
    include LanguagedailyParser::Common

    attr_accessor :page

    def initialize(url)
      http_client = LanguagedailyParser::HttpClient.new(url)
      response = http_client.get
      self.page = Nokogiri::HTML(response)
    end

    def words
      return @words if @words.present?
      @words = {}
      html_node(self.page, '.jsn-article-content .rowA, .jsn-article-content .rowB',
                get_all: true).each do |node|
        original = child_node(node, '.bigLetter').text
        translated = child_node(node, 'td:nth-child(3)').text
        @words["#{original}"] = translated if translated.present?
      end
      @words
    end
  end
end
