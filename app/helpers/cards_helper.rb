# frozen_string_literal: true
module CardsHelper
  def formatted_date(date)
    date.strftime("%d/%m/%Y")
  end

  # Styling flash messages for bootstrap
  def flash_class(level)
    level = level.to_s
    case level
      when 'success' then 'alert alert-success'
      when 'notice' then 'alert alert-info'
      when 'alert' then 'alert alert-danger'
      when 'danger' then 'alert alert-danger'
    end
  end
end
