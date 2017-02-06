# frozen_string_literal: true
require 'open-uri'

module LanguagedailyParser
  class HttpClient
    attr_reader :url, :base_url

    def initialize(url)
      self.url = url
      self.base_url = url
    end

    def get
      open(self.url,
           "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) "\
                           "AppleWebKit/537.36 (KHTML, like Gecko) "\
                           "Chrome/55.0.2883.95 Safari/537.36")
    end

    private

    def url_is_valid?(url)
      uri = URI.parse(url.to_s)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end

    def url=(url)
      raise StandardError.new('URL is not valid!') unless url_is_valid?(url.to_s)
      @url = url.to_s
    end

    def base_url=(url)
      raise StandardError.new('URL is not valid!') unless url_is_valid?(url.to_s)
      uri = URI.parse(url.to_s)
      @base_url = "#{uri.scheme}://#{uri.hostname}"
    end
  end
end
