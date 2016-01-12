require "hangman/console"
require "hangman/choose_random_word"

module Hangman
  
  class Game
    
    attr_reader :ui, :state
    
    def initialize
      @ui = Console.new
      @state = State.new(ChooseRandomWord.call)
    end
   
    def run  
      # display initial stage before user takes any guess
      ui.display_stage(state)
     
      until state.game_over? do
        consume_player_input
        
        ui.display_stage(state)
      end
    end
    
    private

    def consume_player_input
      guess = ui.take_player_guess
      
      if validate_guess(guess)
        state.submit_guess(guess)
      end
    end

    def validate_guess(guess)
      if guess.nil?
        ui.invalid_guess
        return false
      end

      if state.guessed?(guess)
        ui.repeated_guess
        false
      else 
        true
      end
    end
  end
  
end