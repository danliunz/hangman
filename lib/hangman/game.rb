require "hangman/console"
require "hangman/choose_random_word"

module Hangman
  
  class Game
    
    attr_reader :console, :state
    
    def initialize
      @console = Console.new
      @state = State.new(secret: ChooseRandomWord.choose)
    end
   
    def start      
      # display initial stage before user takes any guess
      console.display_stage(state)

      loop do
        one_game_run
        console.display_stage(state)

        if state.game_over?; break end
      end
    end
    
    private

    def one_game_run
      begin
        guess = console.take_user_guess
      rescue IOError # user aborts game
        exit
      end
      
      state.user_guesses << guess if user_guess_valid?(guess)
    end

    def user_guess_valid?(guess)
      if guess.nil?
        console.warn("Come on, make a guess")
        return false
      end

      if state.user_guesses.include?(guess)
        console.warn("Do not make the same guess, try again")
        false
      else 
        true
      end
    end
  end
  
end