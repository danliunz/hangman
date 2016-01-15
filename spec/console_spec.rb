require "hangman/console"
require "hangman/game/state"

RSpec.describe Hangman::Console do
  describe "#take_player_guess" do
    
    let(:player_inputs) { ["a guess\n", "\n", "a guess"] }
    
    it "returns player input with newline chomped" do
      guess = nil
      
      player_inputs.each do |input|
        allow(subject).to receive(:gets).and_return(input)
        
        expect { guess = subject.take_player_guess}.to output(/make a guess/i).to_stdout
        expect(guess).to eq(input.chomp)
      end
    end
    
    describe "#invalid_guess" do
      it "warns properly" do
       expect { subject.invalid_guess }.to output(/invalid guess/i).to_stdout
      end
    end
    
    describe "#repeated_guess" do 
      it "warns properly" do
        expect { subject.repeated_guess }.to output(/do not repeat/i).to_stdout
      end
    end
    
    describe "#wait_for_next_game" do 
      it "prompts and takes player input" do
        allow(subject).to receive(:gets).and_return("\n")
        
        expect { subject.wait_for_next_game }.to output(/new game/i).to_stdout
      end
    end
    
    def expect_correct_stage_when_game_not_over
      expect do
        subject.display_stage(game_not_over)
      end.to output(/word:.*guess:.*misses:/im).to_stdout
    end
    
    describe "#display_stage" do
      let(:secret) { "power" }
      let(:game_not_over) { Hangman::Game::State.new(secret) }
      
      let(:game_is_lost) do
        state = Hangman::Game::State.new(secret)
        %w{1 2 3 4 5 6}.each { |guess| state.submit_guess(guess) }
        state
      end
      
      let(:game_is_won) do
        state = Hangman::Game::State.new(secret)
        secret.chars.each { |guess| state.submit_guess(guess) }
        state
      end
      
      it "displays serect, last guess and misses when game is not over" do
        expect_correct_stage_when_game_not_over
        
        game_not_over.submit_guess("p")

        expect_correct_stage_when_game_not_over        
      end
      
      it "displays secret, last guess, misses and end result when game is lost" do
        expect do
          subject.display_stage(game_is_lost)
       end.to output(/word:.*guess:.*misses:.*lost/im).to_stdout
      end
      
      it "display secret, last guess, misses and end result when game is won" do
        expect do
          subject.display_stage(game_is_won)
        end.to output(/word:.*guess:.*misses:.*won/im).to_stdout
      end
    end
  end
end
