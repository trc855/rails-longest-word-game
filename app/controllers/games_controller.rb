require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map do
      ("A".."Z").to_a[rand(26)]
    end
  end

  def score
    letters = params[:letters].delete("\"").delete("[").delete("]").delete(" ").split(',')
    word = params[:word].upcase

    api_response_parsed = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)
    is_word = api_response_parsed["found"]

    letters_contain_word = letters_in_grid?(letters, word)

    @message = "Congratulations! #{word} is a valid English word!" if is_word && letters_contain_word
    @message = "Sorry but #{word} can't be built out of #{letters.join(", ")}" if !letters_contain_word
    @message = "Sorry but #{word} does not appear to be an english word" if !is_word
  end
end

def letters_in_grid?(grid, attempt)
  grid_temp = grid.clone
  attempt_arr = attempt.clone.chars

  attempt_arr.each do |c|
    if grid_temp.include? c.upcase
      grid_temp.delete_at(grid_temp.index(c.upcase))
    else
      return false
    end
  end
  true
end
