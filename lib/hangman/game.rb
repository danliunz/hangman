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
        consume_player_input
        
        ui.display_stage(state)
      end until state.game_over?
    end
    
    private

    def consume_player_input
      guess = ui.take_player_guess
      
      if !guess.valid?
        ui.invalid_guess
      elsif state.guessed?(guess.content)
        ui.repeated_guess
      else
        state.submit_guess(guess.content)
      end
    end
  end
end