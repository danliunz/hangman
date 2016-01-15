require "hangman/guess_factory"

RSpec.describe Hangman::GuessFactory do
  describe "#new_guess" do
    let(:empty_input) { "" }
    let(:invalid_one_char_inputs) { %w{1 2 , / = : ( ) & @ # %} }
    let(:multiple_char_inputs) { ["ab", "abc", "abcd"] }
    
    it "returns nil for invalid input" do
      expect(described_class.new_guess(empty_input)).to be_nil
      
      invalid_one_char_inputs.each do |input|
        expect(described_class.new_guess(input)).to be_nil
      end
      
      multiple_char_inputs.each do |input|
        expect(described_class.new_guess(input)).to be_nil
      end
    end
    
    let(:valid_inputs) { %w{a b c A B C} }
    
    it "returns downcased guess for valid input" do
      valid_inputs.each do |input|
        expect(described_class.new_guess(input)).to eq(input.downcase)
      end
    end
  end
end
