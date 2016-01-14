module Hangman
  class Game
    class Guess
      
      attr_reader :content
      
      # Valid guess contains single alphabetic character
      def self.valid?(input)
        input =~ /^[[:alpha:]]$/
      end
      
      def initialize(input)
        if self.class.valid?(input)
          @content = input[0].downcase
        end
      end
      
      def valid?
        !@content.nil?
      end
    end
  end
end