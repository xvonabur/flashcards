# frozen_string_literal: true
class CardsController < ApplicationController
  def index
    @cards = Card.all
  end
end
