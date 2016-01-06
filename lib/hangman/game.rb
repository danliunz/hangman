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
        
        if state.game_over?
          console.display_game_over(state)
          break
        end
      end
    end

    private
    
    # User guesses one character, and game processes it
    def one_game_run
      guess = console.take_user_guess
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
      right_guess_num  = 0
      
      state.user_guesses.each do |g|
        right_guess_num += 1 if target.include?(g)
      end
      
      if right_guess_num >= target.size
        state.user_win
      elsif state.user_guesses.size - right_guess_num >= Config::MAX_GUESS_MISS
        state.user_lose
      end 
    end
  end
  
end