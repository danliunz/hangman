require "hangman/game/state"
require "hangman/game/config"

RSpec.describe Hangman::Game::State do
  let(:secret) { "buffer" }
  let(:max_misses) { 6 }
  subject(:game_state) { described_class.new(secret, max_misses: max_misses) }

  def expect_game_not_over
    expect(game_state).not_to be_game_over
    expect(game_state).not_to be_won
    expect(game_state).not_to be_lost
  end
  
  def expect_lost
    expect(game_state).to be_game_over
    expect(game_state).not_to be_won
    expect(game_state).to be_lost
  end
  
  def expect_won
    expect(game_state).to be_game_over
    expect(game_state).to be_won
    expect(game_state).not_to be_lost
  end
  
  context "with no user guess" do
    it "tells the game is not over" do
      expect_game_not_over
      
      expect(game_state.guesses).to be_empty
      expect(game_state.missed_guesses).to be_empty
      expect(game_state.last_guess).to be_nil
    end
  end
  
  context "with user guesses" do
    it "detects repeated guess" do
      %w{a b c}.each { |g| game_state.submit_guess(g) }
      
      %w{a b c}.each { |g| expect(game_state).to be_guessed(g) }
    end
    
    context "less than max misses and secret is not revealed" do
      it "tells game is not over" do
        
        # 3 wrong guesses
        %w{1 2 3}.each { |g| game_state.submit_guess(g)}
       
        # then 1 right guess
        game_state.submit_guess("f")
        
        expect_game_not_over
        expect(game_state.missed_guesses).to match_array(%w{1 2 3})
        expect(game_state.last_guess).to eq("f")
      end
    end
    
    context "too many misses" do
      it "tells the user loses" do
        game_state.submit_guess("b")
        
        %w{1 2 3 4 5 6}.each do |i|
          game_state.submit_guess(i.to_s)
        end
        
        expect_lost
      end
    end
    
    context "reveal the secret" do
      it "tells the user wins the game" do
        # one miss 
        game_state.submit_guess("1")
        
        secret.chars.shuffle.each { |c| game_state.submit_guess(c) }
              
        expect_won
      end
    end
  end
end
