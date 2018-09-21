class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses

  MAX_GUESSES = 7
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def valid_guess(letter)
    if /[[:alpha:]]/.match(letter)
        return false
    end
    return true
  end

  def check_win_or_lose()
    if @wrong_guesses.length >= MAX_GUESSES
        return :lose
    elsif @word.chars.sort_by(&:downcase).join == @guesses.chars.sort_by(&:downcase).join
        return :win
    end
    return :play
  end

  def word_with_guesses()
    displayedWord = ''
    @word.split("").each do |i|
        if @guesses.include? i
            displayedWord += i
        else
            displayedWord += '-'
        end
    end
    return displayedWord
  end

  def guess(letter)
    if (not valid_guess(letter)) || (letter.nil?)
        raise ArgumentError
    elsif (@word.include? letter.downcase) && (not @guesses.include? letter.downcase)
        @guesses+=letter.downcase
        if check_win_or_lose() == :play
            return word_with_guesses()
        else
            return check_win_or_lose()
        end
    elsif (not @word.include? letter.downcase) && (not @wrong_guesses.include? letter.downcase)
        @wrong_guesses+=letter.downcase
        check_win_or_lose()
        return true
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
