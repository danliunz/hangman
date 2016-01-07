require "hangman/choose_random_word"

ChooseWord = Hangman::ChooseRandomWord

describe Hangman::ChooseRandomWord do
  before(:example) do
    @words = []
    1000.times do @words << ChooseWord.choose end
  end
  
  it "chooses a word of proper length" do
    @words.each do |w|
      expect(w.length).to (be >= 4).and (be <= 6)
    end
  end
  
  it "chooses words randomly" do
    expect(@words.size).not_to eq(@words.uniq.size)
  end

end
