require "hangman/console"
module Hangman
  
  class Game
    
    # TODO: choose a word from dictionary randomly
    # Always return the word in lower case
    def self.choose_word
      "kayak".downcase
    end
    
    attr_reader :console, :state
    
    def initialize
      @console = Console.new
      @state = State.new
    end
    
    def start
      
      state.target_word = self.class.choose_word
      
      # display initial stage before user takes any guess
      console.display_stage(state)
      
      loop do
        one_game_run
        console.display_stage(state)
        
        if state.game_over?; break end
      end
    end

    private
    
    # One game run: user guesses one character, game state is updated accordingly
    def one_game_run
      begin
        guess = console.take_user_guess
      rescue IOError # user aborts game
        exit 
      end
      
      if !validate_user_guess(guess); return end

      state.user_guesses << guess
      refresh_game_state
    end
    
    def validate_user_guess(guess)
      if !guess
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
    
    def refresh_game_state
      target = state.target_word.chars.uniq
      
      right_guesses = 
        state.user_guesses.inject(0) do |r, guess|
          target.include?(guess) ? r + 1 : r
        end
      
      if right_guesses >= target.size
        state.user_win
      elsif state.user_guesses.size - right_guesses >= Config::MAX_GUESS_MISS
        state.user_lose
      end 
    end
  end
  
end