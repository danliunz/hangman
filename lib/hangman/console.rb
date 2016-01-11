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
      display("Make a guess pleass\n")
    end
    
    def repeated_guess
      display("Do not repeat prior guess\n")
    end

    def display(msg)
      print msg
    end
    
    private
    
    def display_game_result(game_state)
      if game_state.user_won?
        puts "You have won!"
      elsif game_state.user_lost?
        puts "You have lost..."
        
        print "The secret word is: "
        game_state.reveal_secret(self)
        
        puts
      end
    end
    
    def display_secret(game_state)
      puts "Word: #{game_state.underscored_secret.join}"
    end
    
    def display_last_guess(game_state)
      print "Guess: "
      print "#{game_state.last_guess}" if game_state.last_guess
      puts
    end
    
    def display_misses(game_state)
      print "Misses: "
        
      misses = game_state.missed_user_guesses
      print misses.join(",")
      puts " (#{game_state.max_misses - misses.size} chances left)"
    end
  end
  
end