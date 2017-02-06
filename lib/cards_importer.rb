# frozen_string_literal: true
class CardsImporter
  attr_reader :url

  def initialize(url)
    @url = url.to_s
  end

  def import
    page_links.each do |link|
      page = send_request(link)
      words = extract_words(page)
      import_cards(words)
    end
  end

  private

  def send_request(url)
    Nokogiri::HTML(open(url))
  end

  def page_links
    first_page = send_request(self.url)

    page_links = [self.url]
    first_page.css('.jsn-article-content ul li a').each do |node|
      relative_link = node['href']
      if relative_link.present?
        link = "#{base_url(self.url)}#{relative_link}"
        page_links << link
      end
    end
    page_links
  end

  def base_url(url)
    uri = URI.parse(url.to_s)
    "#{uri.scheme}://#{uri.hostname}"
  end

  def extract_words(page)
    words = {}
    page.css('.jsn-article-content .rowA, .jsn-article-content .rowB').each do |node|
      original = extract_html_child(node, '.bigLetter')
      translated = extract_html_child(node, 'td:nth-child(3)')
      words["#{original}"] = translated if translated.present?
    end
    words
  end

  def extract_html_child(node, css)
    node.children.css(css.to_s).first.text
  end

  def import_cards(words)
    return if words.blank?
    Card.transaction do
      words.map do |key, value|
        Card.create(original_text: key, translated_text: value)
      end
    end
  end
end
