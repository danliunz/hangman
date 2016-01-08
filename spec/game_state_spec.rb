require "hangman/game/state"
require "hangman/game/config"

describe Hangman::Game::State do
  def expect_game_not_over
    expect(@game_state.game_over?).to be false
    expect(@game_state.user_win?).to be false
    expect(@game_state.user_lose?).to be false
  end
  
  def expect_user_lose
    expect(@game_state.game_over?).to be true
    expect(@game_state.user_win?).to be false
    expect(@game_state.user_lose?).to be true  
  end
  
  def expect_user_win
    expect(@game_state.game_over?).to be true
    expect(@game_state.user_win?).to be true
    expect(@game_state.user_lose?).to be false  
  end
  
  before(:example) do
    @game_state = Hangman::Game::State.new(secret: "power")
  end
  
  context "initial state(no user guesses)" do
    it "ensures game is not over yet" do
      expect_game_not_over
      
      expect(@game_state.user_guesses).to be_empty
      expect(@game_state.missed_user_guesses).to be_empty
      expect(@game_state.last_guess).to be_nil
    end
  end
  
  context "game with user guesses" do
    it "detects repeated guess" do
      @game_state.take_new_guess("a", "b", "c")
      
      expect do
        @game_state.take_new_guess("a")  
      end.to raise_error(ArgumentError)
    end
    
    it "is still open game after user misses for " +
       "< #{Hangman::Game::Config::MAX_GUESS_MISS} times" do
      
      # 1. guess 'x', wrong
      @game_state.take_new_guess("x")
      
      expect_game_not_over
      expect(@game_state.last_guess).to eq("x")
      expect(@game_state.missed_user_guesses).to include("x")
      expect(@game_state.missed_user_guesses.size).to eq(1)
      
      # 2. guess 'y', wrong again
      @game_state.take_new_guess("y")
      
      expect_game_not_over
      expect(@game_state.last_guess).to eq("y")
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y")
      
      # 3. guess 'p', right
      @game_state.take_new_guess("p")
      
      expect_game_not_over
      expect(@game_state.last_guess).to eq("p")
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y")
      
      # 4. guess 'z', wrong again
      @game_state.take_new_guess("z")
      
      expect_game_not_over
      expect(@game_state.last_guess).to eq("z")
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y", "z")
    end
    
    it "is over(user lose) after user misses " + 
       "#{Hangman::Game::Config::MAX_GUESS_MISS} guesses" do
      @game_state.take_new_guess("p")
      
      Hangman::Game::Config::MAX_GUESS_MISS.times do |i|
        @game_state.take_new_guess(i.to_s)
      end
      
      expect_user_lose
    end
    
    it "is over(user win) after user guesses all secret chars" do
      @game_state.secret.shuffle.each { |c| @game_state.take_new_guess(c) }
            
      expect_user_win
    end
    
    it "is over(user win) after user guesses all secret chars with a few misses" do
      @game_state.take_new_guess("1", "2", "3")
      @game_state.take_new_guess(*(@game_state.secret))
      
      expect_user_win
    end
  end
end
