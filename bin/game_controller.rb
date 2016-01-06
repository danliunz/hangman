$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib")

require "hangman/game"

class GameController
  def self.run_game
    Hangman::Game.new.start
  end
end


if __FILE__ == $0
  GameController.run_game
end