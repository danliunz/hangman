require "hangman/game/state"
require "hangman/game/config"
module Hangman
  
  # Terminal to output game status
  class Console
    
    # Return nil if user input is unavailable
    def take_user_guess
      $stdout.print("Make a guess: ")
      
      begin
        guess = $stdin.gets
        if guess.nil? # user enters ctrl+d
          raise IOError, "User aborts game"
        end
        
        guess = guess.chomp[0]
      rescue Interrupt # user enters ctrl+c, ask to guess
        guess = nil
      end
      
      guess = guess && guess.downcase
    end
    
    def display_stage(game_state) 
      $stdout.puts
      
      display_secret(game_state)
      display_last_guess(game_state)
      display_misses(game_state)
      
      $stdout.puts
      
      display_game_result(game_state)
    end
    
    def warn(msg) 
      $stdout.puts(msg)
    end
    
    private
    
    def display_game_result(game_state)
      if game_state.user_win?
        $stdout.puts("You have won!")
      elsif game_state.user_lose?
        $stdout.puts("You have lost...")
        $stdout.puts("The secret word is: #{game_state.secret.join}")
      end
    end
    
    def display_secret(game_state)
      $stdout.print("Word: ")
      
      game_state.secret.each do |c|
        if game_state.user_guesses.include?(c)
          $stdout.print("#{c} ")
        else
          $stdout.print("_ ")
        end
      end
      
      $stdout.puts
    end
    
    def display_last_guess(game_state)
      $stdout.print("Guess: ")
      
      last_guess = game_state.user_guesses[-1]
      $stdout.print("#{last_guess}") if last_guess
      
      $stdout.puts
    end
    
    def display_misses(game_state)
      $stdout.print("Misses: ")
        
      misses = game_state.missed_user_guesses
      $stdout.print(misses.join(","))
      $stdout.puts(" (#{Game::Config::MAX_GUESS_MISS - misses.size} chances left)")
    end
  end
  
end