#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib")

require "hangman/game"
require "hangman/console"
require "hangman/choose_random_word"

if __FILE__ == $0
  begin
    loop do
      ui = Hangman::Console.new
      secret = Hangman::ChooseRandomWord.call
      
      game = Hangman::Game.new(ui, secret)
      game.play
      
      ui.wait_for_next_game
    end
  rescue Interrupt
    # User decides to quit application(e.g  by pressing ctrl+c).
    # Catch and ignore the exception to avoid messy stack trace output
  end
end