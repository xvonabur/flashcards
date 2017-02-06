# frozen_string_literal: true
module LanguagedailyParser
  module Common
    def html_node(page, css, options = {})
      return page.css("#{css}") if options[:get_all]
      page.css("#{css}").first
    end

    def child_node(node, css)
      children = node.children
      return nil if children.blank? || children.css(css).blank?
      children.css(css).first
    end
  end
end
