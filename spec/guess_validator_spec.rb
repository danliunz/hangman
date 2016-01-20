require "hangman/guess_validator"

RSpec.describe Hangman::GuessValidator do
  describe "#valid?" do
    let(:empty_input) { "" }
    let(:invalid_one_char_inputs) { %W{1 2 , / = : ( ) & @ # % \n} }
    let(:multiple_char_inputs) { ["ab", "abc", "abcd"] }
    
    it "return false for invalid input" do
      expect(described_class.valid?(empty_input)).to be false
      
      invalid_one_char_inputs.each do |input|
        expect(described_class.valid?(input)).to be false
      end
      
      multiple_char_inputs.each do |input|
        expect(described_class.valid?(input)).to be false
      end
    end
    
    let(:valid_inputs) { %w{a b c A B C} }
    
    it "returns true for valid input" do
      valid_inputs.each do |input|
        expect(described_class.valid?(input)).to be true
      end
    end
  end
end
