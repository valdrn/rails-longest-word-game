require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :set_letters

  def new
  end

  def score
    @result = nil
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word = URI.open(url).read
    word_verified = JSON.parse(word)


    if word_verified['found']
      attempt_array = @word.upcase.chars
      status = grid_include?(attempt_array, @letters)
      if status == false
        @result = "Sorry but #{@word} can't be make out of the given letters"
      else
        @result = 'Congratulations'
      end
    else
      @result = "Sorry but #{@word} doesn't seem to be an English word"
    end
    @result
  end

  def grid_include?(attempt_array, grid_array)
    # Vérifie si chaque lettre de "attempt" est dans grid et est utilisée une seule fois
    resultat = nil
    attempt_array.each do |letter|
      if grid_array.include?(letter)
        grid_array.delete(letter)
        resultat = true
      else
        resultat = false
      end
    end
    resultat
  end

  private


  def set_letters
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end
end
