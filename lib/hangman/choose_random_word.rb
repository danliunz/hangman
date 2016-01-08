module Hangman

class ChooseRandomWord  
  # Return a random English word from dictionary.
  # The word will be used in a Hangman game
  def self.choose
    @words.sample
  end
  
  private
  
  def self.build_word_list
    @words = File.open("/usr/share/dict/words")
      .readlines
      .map { |line| line.chomp.downcase }
      .select { |line| (4..6).cover?(line.length) }
    
  rescue IOError => e
    $stderr.puts("Fail to initialize game, aborting...")
    raise
  end
  
  build_word_list
  
end

end