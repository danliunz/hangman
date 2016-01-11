require "hangman/game/state"
require "hangman/game/config"
module Hangman
  
  # Terminal to output game status
  class Console
    
    def take_user_guess
      print("Make a guess: ")
      
      # If user presses ctrl+d or just a newline char,
      # return nil indicating invalid input
      s = gets
      s && s.length > 1 ? s[0].downcase : nil
    end
    
    def display_stage(game_state) 
      puts
      
      display_secret(game_state)
      display_last_guess(game_state)
      display_misses(game_state)
      
      puts
      
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
      puts(msg)
    end
    
    def display_game_result(game_state)
      if game_state.user_won?
        puts("You have won!")
      elsif game_state.user_lost?
        puts("You have lost...")
        puts("The secret word is: #{game_state.secret.join}")
      end
    end
    
    def display_secret(game_state)
      print("Word: ")

      result = 
        game_state.secret.map do |c|
          game_state.guessed?(c) ? "#{c} " : "_ "
        end
      
      puts result.join
    end
    
    def display_last_guess(game_state)
      print("Guess: ")
      print("#{game_state.last_guess}") if game_state.last_guess
      puts
    end
    
    def display_misses(game_state)
      print("Misses: ")
        
      misses = game_state.missed_user_guesses
      print(misses.join(","))
      puts(" (#{game_state.max_misses - misses.size} chances left)")
    end
  end
  
end