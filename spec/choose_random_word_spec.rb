require "hangman/choose_random_word"

RSpec.describe Hangman::ChooseRandomWord do
  let(:words) { Array.new(1000) { subject.class.choose } }
 
  it "chooses a word of proper length" do
    words.each do |w|
      expect(w.length).to be_between(4, 6)
    end
  end

  it "chooses words randomly" do
    expect(words.size).not_to eq(words.uniq.size)
  end
end
