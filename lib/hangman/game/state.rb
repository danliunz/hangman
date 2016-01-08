module Hangman
class Game
    
  class State
    
    # the word which player guesses, stored as array of chars
    attr_accessor :secret
    
    def initialize(secret: )
      self.secret = secret.split(//)
    end
    
    def submit_guess(*guess)
      raise ArgumentError, "nil guess disallowed" if guess.include?(nil)
      
      if guess.any? { |g| guess_before?(g) }
        raise ArgumentError, "repeated guess disallowed" 
      end
      
      user_guesses.push(*guess)
    end
    
    def guess_before?(guess) 
      user_guesses.include?(guess)
    end
    
    def last_guess
      user_guesses[-1]
    end
    
    # the characters user has guessed so far
    def user_guesses
      @user_guesses ||= []
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
      missed_user_guesses.size >= Config::MAX_GUESS_MISS
    end
  end

end
end