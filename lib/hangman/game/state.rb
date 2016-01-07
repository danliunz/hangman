module Hangman
class Game
    
  class State
    
    # the word which player guesses, stored as array of chars
    attr_accessor :secret
    
    def initialize(secret: )
      self.secret = secret.split(//)
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