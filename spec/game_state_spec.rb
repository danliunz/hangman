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
    let(:three_wrong_guesses) { %w{x y z} }
    
    it "detects repeated guess" do
      three_wrong_guesses.each { |g| game_state.submit_guess(g) }
      
      three_wrong_guesses.each { |g| expect(game_state).to be_guessed(g) }
    end
    
    context "less than max misses and secret is not revealed" do
      let(:three_wrong_guesses) { %w{x y z} }
      let(:one_right_guess) { "f" }
      
      it "tells game is not over" do        
        three_wrong_guesses.each { |g| game_state.submit_guess(g)}
       
        game_state.submit_guess(one_right_guess)
        
        expect_game_not_over
        expect(game_state.missed_guesses).to match_array(three_wrong_guesses)
        expect(game_state.last_guess).to eq(one_right_guess)
      end
    end
    
    context "too many misses" do
      let(:six_wrong_guesses) { %w{o p q x y z} }
      let(:one_right_guess) { "b" }
      
      it "tells the user loses" do
        game_state.submit_guess(one_right_guess)
        
        six_wrong_guesses.each do |i|
          game_state.submit_guess(i.to_s)
        end
        
        expect_lost
      end
    end
    
    context "reveal the secret" do
      let(:one_wrong_guess) { "x" }
      
      it "tells the user wins the game" do
        # one miss 
        game_state.submit_guess(one_wrong_guess)
        
        secret.chars.shuffle.each { |c| game_state.submit_guess(c) }
              
        expect_won
      end
    end
  end
end
