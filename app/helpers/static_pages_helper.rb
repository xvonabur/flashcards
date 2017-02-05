# frozen_string_literal: true
module StaticPagesHelper
  def navbar_item_class(base_class, path)
    return base_class unless current_page? path
    "#{base_class} active"
  end
end
