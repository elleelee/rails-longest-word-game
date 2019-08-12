require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:score] = 0 if session[:score].nil?
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    # raise
    run_game(params[:word], params[:grid].chars)
    @score = session[:score]
    # return @score
  end

  def checking_grid(attempt, grid)
    attempt_split = attempt.upcase.chars
    attempt_split.each do |a|
      return false if attempt_split.count(a) > grid.count(a)
    end
    true
  end

  def run_game(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    words_serialized = open(url).read
    words = JSON.parse(words_serialized)

    if words["found"] && checking_grid(attempt, grid)
      @word = "Congratulations! #{params[:word].upcase} is a valid English word!"
      session[:score] += params[:word].length
    elsif words["found"] && !checking_grid(attempt, grid)
      @word = "Sorry but #{params[:word].upcase} can't be built out of #{params[:grid]}"
      session[:score] += 0
    else
      @word = "Sorry but #{params[:word].upcase} does not seem to be a valid English word..."
      session[:score] += 0
    end
  end
end
