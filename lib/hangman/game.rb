require "hangman/guess_factory"

module Hangman
  class Game
    attr_reader :ui, :state
    
    def initialize(ui, secret)
      @ui = ui
      @state = State.new(secret)
    end
   
    def play
      ui.display_stage(state)
     
      begin
        guess = take_player_guess
        process_player_guess(guess)
        
      end until state.game_over?
    end
    
    private

    def take_player_guess
      GuessFactory.new_guess(ui.take_player_guess)
    end
    
    def process_player_guess(guess)
      if guess.nil?
        ui.invalid_guess
      elsif state.guessed?(guess)
        ui.repeated_guess
      else
        state.submit_guess(guess)
        ui.display_stage(state)
      end
    end
  end
end