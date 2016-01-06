require "hangman/game/state"
require "hangman/game/config"
module Hangman
  
  # Terminal to output game status
  class Console
    
    def take_user_guess
      $stdout.print("Make a guess: ")
      
      # beware of ctrl+d and ctrl+c key combination
      # instead of quitting inelegantly, we ask user to re-guess
      begin
        guess = $stdin.gets
        guess = guess && guess.chomp[0]
      rescue Interrupt
        guess = nil
      end
      
      guess = guess && guess.downcase
    end
    
    def display_stage(game_state) 
      display_target_word(game_state)
      display_last_guess(game_state)
      display_misses(game_state)
      
      $stdout.puts
      
    end
    
    def display_game_over(game_state)
      if game_state.user_win?
        $stdout.puts("You have won!")
      elsif game_state.user_lose?
        $stdout.puts("You have lost...")
      else 
        raise "Game internal error, invalid game status #{game_state}"
      end
    end
    
    def warn(msg) 
      $stdout.puts(msg)
    end
    
    private
    
    def display_target_word(game_state)
      $stdout.print("Word: ")
      
      game_state.target_word.chars.each do |c|
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
      
      target = game_state.target_word.chars
      misses = game_state.user_guesses.reject { |g| target.include?(g) }
      $stdout.print(misses.join(","))
      $stdout.puts(" (#{Game::Config::MAX_GUESS_MISS - misses.size} chances left)")
    end
  end
  
end