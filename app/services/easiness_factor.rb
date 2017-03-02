# frozen_string_literal: true
class EasinessFactor
  def initialize(quality)
    @quality = quality.to_i
  end

  def calc(last_factor)
    raise StandardError.new 'Blank last_factor value' if last_factor.blank?
    factor = last_factor + (0.1 - (5 - @quality) * (0.08 + (5 - @quality) * 0.02))
    factor < 1.3 ? 1.3 : factor
  end
end
