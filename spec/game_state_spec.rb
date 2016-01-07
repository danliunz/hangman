require "hangman/game/state"
require "hangman/game/config"

describe Hangman::Game::State do
  def game_not_over
    expect(@game_state.game_over?).to be false
    expect(@game_state.user_win?).to be false
    expect(@game_state.user_lose?).to be false
  end
  
  def user_lose
    expect(@game_state.game_over?).to be true
    expect(@game_state.user_win?).to be false
    expect(@game_state.user_lose?).to be true  
  end
  
  def user_win
    expect(@game_state.game_over?).to be true
    expect(@game_state.user_win?).to be true
    expect(@game_state.user_lose?).to be false  
  end
  
  before(:example) do
    @game_state = Hangman::Game::State.new(secret: "power")
  end
  
  context "initial state(no user guesses)" do
    it "ensures game is not over yet" do
      game_not_over
      
      expect(@game_state.user_guesses).to be_empty
      expect(@game_state.missed_user_guesses).to be_empty
    end
  end
  
  context "game with user guesses" do
    it "is still open game after user misses for " +
       "< #{Hangman::Game::Config::MAX_GUESS_MISS} times" do
      
      # 1. guess 'x', wrong
      @game_state.user_guesses << "x"
      
      game_not_over
      expect(@game_state.missed_user_guesses).to include("x")
      expect(@game_state.missed_user_guesses.size).to eq(1)
      
      # 2. guess 'y', wrong again
      @game_state.user_guesses << "y"
      
      game_not_over
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y")
      
      # 3. guess 'p', right
      @game_state.user_guesses << "p"
      
      game_not_over
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y")
      
      # 4. guess 'z', wrong again
      @game_state.user_guesses << "z"
      
      game_not_over
      expect(@game_state.missed_user_guesses).to contain_exactly("x", "y", "z")
    end
    
    it "is over(user lose) after user misses " + 
       "#{Hangman::Game::Config::MAX_GUESS_MISS} guesses" do
      @game_state.user_guesses << "p" 
      
      1.upto(Hangman::Game::Config::MAX_GUESS_MISS) do |i|
        @game_state.user_guesses << i.to_s
      end
      
      user_lose
    end
    
    it "is over(user win) after user guesses all secret chars" do
      @game_state.secret.shuffle.each { |c| @game_state.user_guesses << c }
            
      user_win
    end
    
    it "is over(user win) after user guesses all secret chars with a few misses" do
      @game_state.user_guesses << "1" << "2" << "p" << "3"
      @game_state.user_guesses.insert(-1, *(@game_state.secret))
      
      user_win
    end
  end
end
