module Hangman
class Game
    
  class State
    UNDECIDED = 0
    USER_WIN = 1
    USER_LOSE = 2

    attr_reader :end_result
    
    # the word which player guesses
    attr_accessor :target_word
    
    # the characters user has guessed so far
    def user_guesses
      @user_guesses ||= []
    end
    
    def initialize
      @end_result = UNDECIDED
    end
    
    def game_over?
      end_result != UNDECIDED
    end

    def user_win?
      end_result == USER_WIN
    end
    
    def user_win
      @end_result = USER_WIN
    end
    
    def user_lose?
      end_result == USER_LOSE
    end
    
    def user_lose
      @end_result = USER_LOSE
    end
  end

end
end