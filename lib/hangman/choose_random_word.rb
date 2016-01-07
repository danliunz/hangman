module Hangman

class ChooseRandomWord  
  # Return a random English word from dictionary.
  # The word will be used in a Hangman game
  def self.choose
    words.sample
  end
  
  private
  
  def self.words
    @words ||= []
  end
  
  def self.build_word_list
    File.open("/usr/share/dict/words") do |f|
      f.each do |line|
        line = line && line.chomp
        words << line.downcase if (4..6).cover?(line.length)
      end
    end
    
  rescue IOError => e
    $stderr.puts("Fail to initialize game, aborting...")
    raise
  end
  
  build_word_list
  
end

end