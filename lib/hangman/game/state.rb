module Hangman
class Game
    
  class State
    
    # secret is stored as an array of chars
    attr_reader :secret
    attr_reader :user_guesses, :max_misses
    
    def initialize(secret:, max_misses:)
      @secret = secret.split(//)
      @max_misses = max_misses
      @user_guesses = []
    end
    
    def submit_guess(guess)
      raise ArgumentError, "duplicate guess #{guess}" if user_guesses.include?(guess)
      
      user_guesses.push(guess)
    end
    
    def guess_before?(guess)
      user_guesses.include?(guess)
    end
    
    def last_guess
      user_guesses.last
    end
    
    # the guesses user has missed so far
    def missed_user_guesses
      user_guesses.reject { |g| secret.include?(g) }
    end
    
    def game_over?
      user_win? || user_lose?
    end

    def user_win?
      user_guesses.size - missed_user_guesses.size() >= secret.uniq.size
    end
    
    def user_lose?
      missed_user_guesses.size >= max_misses
    end
  end

end
end