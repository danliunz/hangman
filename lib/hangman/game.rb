require "hangman/console"
require "hangman/choose_random_word"

module Hangman
  
  class Game
    
    attr_reader :ui, :state
    
    def initialize
      @ui = Console.new
      @state = State.new(secret: ChooseRandomWord.choose)
    end
   
    def start      
      # display initial stage before user takes any guess
      ui.display_stage(state)

      loop do
        consume_user_input
        
        ui.display_stage(state)

        break if state.game_over?
      end
    end
    
    private

    def consume_user_input
      begin
        guess = ui.take_user_guess
      rescue IOError # user aborts game
        exit
      end
      
      state.submit_guess(guess) if user_guess_valid?(guess)
    end

    def user_guess_valid?(guess)
      if guess.nil?
        ui.invalid_guess
        return false
      end

      if state.guess_before?(guess)
        ui.repeated_guess
        false
      else 
        true
      end
    end
  end
  
end