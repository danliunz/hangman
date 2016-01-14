module Hangman
  class GuessFactory
    
    # Return nil if +input+ is invalid
    def self.new_guess(input)
      single_alpha_char?(input) ? input.downcase : nil
    end
    
    private
    
    def self.single_alpha_char?(input)
      input =~ /^[[:alpha:]]$/
    end
    
  end
end