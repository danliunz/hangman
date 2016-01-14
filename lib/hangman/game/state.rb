require "hangman/game/config"

module Hangman
class Game
    
  class State
    attr_reader :secret, :guesses, :max_misses
    
    def initialize(secret, max_misses: Config::MAX_GUESS_MISS)
      @secret = secret.chars
      @max_misses = max_misses
      @guesses = []
    end
    
    def submit_guess(guess)
      guesses << guess
    end
    
    def guessed?(guess)
      guesses.include?(guess)
    end
    
    def last_guess
      guesses.last
    end
    
    # the guesses player has missed so far
    def missed_guesses
      guesses - secret
    end
    
    def game_over?
      won? || lost?
    end

    def won?
      (secret - guesses).empty?
    end
    
    def lost?
      missed_guesses.size >= max_misses
    end    
  end

end
end