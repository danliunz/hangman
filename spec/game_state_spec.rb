require "hangman/game/state"
require "hangman/game/config"

describe Hangman::Game::State do
  let(:secret) { "power" }
  let(:max_misses) { 6 }
  subject(:game_state) { described_class.new(secret: secret, max_misses: max_misses) }

  def expect_game_not_over
    expect(game_state).not_to be_game_over
    expect(game_state).not_to be_user_win
    expect(game_state).not_to be_user_lose
  end
  
  def expect_user_lose
    expect(game_state).to be_game_over
    expect(game_state).not_to be_user_win
    expect(game_state).to be_user_lose
  end
  
  def expect_user_win
    expect(game_state).to be_game_over
    expect(game_state).to be_user_win
    expect(game_state).not_to be_user_lose
  end
  
  context "with no user guess" do
    it "tells the game is not over" do
      expect_game_not_over
      
      expect(game_state.user_guesses).to be_empty
      expect(game_state.missed_user_guesses).to be_empty
      expect(game_state.last_guess).to be_nil
    end
  end
  
  context "with user guesses" do
    it "detects repeated guess" do
      %w{a b c}.each { |g| game_state.submit_guess(g) }
      
      %w{a b c}.each { |g| expect(game_state).to be_guess_before(g) }
      
      expect do
        game_state.submit_guess("a")  
      end.to raise_error(ArgumentError)
    end
    
    context "less than max misses and serect is not revealed" do
      it "tells game is not over" do
        
        # 1. guess 'x', wrong
        game_state.submit_guess("x")
        
        expect_game_not_over
        expect(game_state.last_guess).to eq("x")
        expect(game_state.missed_user_guesses).to contain_exactly("x")
        
        # 2. guess 'y', wrong again
        game_state.submit_guess("y")
        
        expect_game_not_over
        expect(game_state.last_guess).to eq("y")
        expect(game_state.missed_user_guesses).to contain_exactly("x", "y")
        
        # 3. guess 'p', right
        game_state.submit_guess("p")
        
        expect_game_not_over
        expect(game_state.last_guess).to eq("p")
        expect(game_state.missed_user_guesses).to contain_exactly("x", "y")
        
        # 4. guess 'z', wrong again
        game_state.submit_guess("z")
        
        expect_game_not_over
        expect(game_state.last_guess).to eq("z")
        expect(game_state.missed_user_guesses).to contain_exactly("x", "y", "z")
      end
    end
    
    context ">= max misses" do
      it "tells the user loses" do
        game_state.submit_guess("p")
        
        game_state.max_misses.times do |i|
          game_state.submit_guess(i.to_s)
        end
        
        expect_user_lose
      end
    end
    
    context "reveal the secret" do
      it "tells the user wins the game" do
        # one miss 
        game_state.submit_guess("1")
        
        secret.split(//).shuffle.each { |c| game_state.submit_guess(c) }
              
        expect_user_win
      end
    end
   
  end
end
