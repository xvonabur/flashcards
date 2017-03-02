# frozen_string_literal: true
class SuperMemoCalculator
  def initialize(args)
    @params = { seconds: args[:seconds].to_i }
    @params[:right_answer] = !!args[:right_answer]
    @params[:last_factor] = args[:last_factor]
    @params[:last_rep_number] = args[:last_rep_number].to_i
    @params[:last_interval] = args[:last_interval].to_i
  end

  def quality
    @params[:quality] ||= if @params[:seconds] < 11
                            @params[:right_answer] ? 5 : 2
                          elsif @params[:seconds] < 30
                            @params[:right_answer] ? 4 : 1
                          else
                            @params[:right_answer] ? 3 : 0
                          end
  end

  def factor
    @params[:factor] ||= EasinessFactor.new(quality).calc(@params[:last_factor])
  end

  def rep_number
    @params[:rep_number] ||= quality < 3 ? 1 : @params[:last_rep_number] + 1
  end

  def interval
    @params[:interval] ||=
      InterRepetitionInterval.new(rep_number).calc(factor, @params[:last_interval])
  end
end
