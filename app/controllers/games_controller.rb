require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def answerInGrid?(attempt, grid)
  counter = 0
  grid_delete = grid
  attempt.each do |letter|
    letter_matches = false
    grid_delete.each_with_index do |letter_grid, index_grid|
      letter_matches = true if letter.downcase == letter_grid.downcase
      grid_delete.delete_at(index_grid) if letter.downcase == letter_grid.downcase
    end
    counter += 1 if letter_matches == true
  end
  counter == attempt.length
  end

  def inEnglish?(answer)
    JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{answer}").read)["found"]
  end

  def score
    answer = params[:answer].upcase.split("").sort!
    letters = params[:letters].upcase.split("").sort!
    if answerInGrid?(answer, params[:letters].upcase.split("").sort!) and inEnglish?(params[:answer])
      @message = "Congratulations! #{params[:answer].upcase} is a valid English word!"
    elsif answerInGrid?(answer, params[:letters].upcase.split("").sort!) and !inEnglish?(params[:answer])
      @message = "Sorry but #{params[:answer].upcase} does not seem to be in English.."
    elsif !answerInGrid?(answer, params[:letters].upcase.split("").sort!)
      @message = "Sorry but #{params[:answer].upcase} can't be built out of #{letters}"
    end
  end
end
