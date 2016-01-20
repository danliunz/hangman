module Hangman
  class GuessValidator
    
    def self.valid?(input)
      single_alpha_char?(input)
    end
    
    private
    
    def self.single_alpha_char?(input)
      not input.match(/^[[:alpha:]]$/).nil?
    end
    
  end
end