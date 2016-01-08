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
    
    def invalid_guess
      warn("Make a guess please")
    end
    
    def repeated_guess
      warn("Do not repeat prior guess")
    end

    private
    
    def warn(msg) 
      $stdout.puts(msg)
    end
    
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
      
      $stdout.puts(
        game_state.secret.map do |c|
          game_state.guess_before?(c) ? "#{c} " : "_ "
        end.join
      )
      
    end
    
    def display_last_guess(game_state)
      $stdout.print("Guess: ")
      $stdout.print("#{game_state.last_guess}") if game_state.last_guess
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