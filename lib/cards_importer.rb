# frozen_string_literal: true
require 'languagedaily_parser'

class CardsImporter
  attr_reader :page_links

  def initialize(start_url)
    page_list = LanguagedailyParser::PageList.new(start_url.to_s)
    @page_links = page_list.page_links
  end

  def import
    self.page_links.each do |link|
      page = LanguagedailyParser::Page.new(link)
      create_cards(page.words)
    end
  end

  private

  def create_cards(words)
    return if words.blank?
    Card.transaction do
      words.map do |key, value|
        Card.create(original_text: key, translated_text: value)
      end
    end
  end
end
