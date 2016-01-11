require "set"

module Hangman
class Game
    
  class State
    attr_reader :secret, :user_guesses, :max_misses
    
    def initialize(secret, max_misses: Config::MAX_GUESS_MISS)
      @secret = secret.split(//)
      @max_misses = max_misses
      @user_guesses = []
    end
    
    def submit_guess(guess)
      user_guesses << guess unless guessed?(guess)
    end
    
    def guessed?(guess)
      user_guesses.include?(guess)
    end
    
    def last_guess
      user_guesses.last
    end
    
    # the guesses user has missed so far
    def missed_user_guesses
      user_guesses - secret
    end
    
    def game_over?
      user_won? || user_lost?
    end

    def user_won?
      (secret - user_guesses).empty?
    end
    
    def user_lost?
      missed_user_guesses.size >= max_misses
    end    
  end

end
end