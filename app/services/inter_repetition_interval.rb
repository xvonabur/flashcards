# frozen_string_literal: true
class InterRepetitionInterval
  def initialize(rep_number)
    @rep_number = rep_number.to_i
  end

  def calc(easiness_factor = nil, last_interval = nil)
    if @rep_number > 2
      raise StandardError.new 'Blank last_interval value' if last_interval.blank?
      raise StandardError.new 'Blank easiness_factor value' if easiness_factor.blank?
    end

    case @rep_number
      when 1 then 1
      when 2 then 6
      else (last_interval * easiness_factor).to_f.ceil
    end
  end
end
