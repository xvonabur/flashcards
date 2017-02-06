# frozen_string_literal: true
require 'cards_importer'

url = 'http://www.languagedaily.com/learn-german/vocabulary/common-german-words'
CardsImporter.new(url).import
