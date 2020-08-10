require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters.push(alphabet.sample) }
  end

  def score
    word = params[:word].upcase
    @letters = params[:letters]

    if in_the_grid?(word, @letters) == false
      @result = "Sorry but #{word} can't be build out of #{@letters}. Your current score is #{SCORE_CONFIG["score"]}."
    elsif english_word?(word) == false
      @result = "Sorry but #{word} does not seem to be a valid English word. Your current score is #{SCORE_CONFIG["score"]}."
    else
      SCORE_CONFIG["score"] += word.length
      @result = "Congratulations! #{word} is a valid English word! You current score is #{SCORE_CONFIG["score"]}."
    end
  end

  private

  def in_the_grid?(word, letters)
    word_letters = word.split("")
    word_array = []

    word_letters.each { |character| word_array.push(character) if letters.include?(character) }

    word.length == word_array.length
  end

  def parsing(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    answer_serialized = open(url).read
    JSON.parse(answer_serialized)
  end

  def english_word?(word)
    parsing(word)
    parsing(word)['found']
  end
end
