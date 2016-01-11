$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib")

require "hangman/game"

if __FILE__ == $0
  loop do
    begin
      Hangman::Game.new.run
      
      puts "\nEnter any key to start a new game"
      gets
    rescue Interrupt # user aborts whole game
      exit
    end
  end
end