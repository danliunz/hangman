require "hangman/choose_random_word"

RSpec.describe Hangman::ChooseRandomWord do
  let(:words) { Array.new(1000) { subject.class.call } }
  
  it "chooses a word of proper length" do
    words.each do |w|
      expect(w.length).to be_between(4, 6)
    end
  end
  
  # randomness test: numerous repeat of single word out of
  # a large sample base is *very* unlikely to happen 
  # so we can safely assume the test case will always pass
  it "chooses words randomly" do    
    words.uniq.each do |word|
      expect(words.count(word)).to be <= 3
    end 
  end
end

