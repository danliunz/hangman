module Hangman

  class ChooseRandomWord    
    # Return a random English word from dictionary
    def self.choose
      words.sample
    end
    
    private
    
    def self.words
      @words ||= begin
        File.open("/usr/share/dict/words")
          .readlines
          .map { |line| line.chomp.downcase }
          .select { |line| line.length.between?(4, 6) }
      end
    end
  end

end