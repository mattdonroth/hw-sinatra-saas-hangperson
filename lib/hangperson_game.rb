class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  MAX_GUESSES = 7
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word, :guesses, :wrong_guesses


  def check_win_or_lose()
    if @wrong_guesses.length >= MAX_GUESSES
        return :lose
    elsif (@word.chars|[]).sort == (@guesses.chars|[]).sort
        return :win
    else
        return :play
    end
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
    if letter == '' or letter == nil or !(letter =~ /[A-Za-z]/)
        raise ArgumentError
    end
    letter.downcase!
    if @word.include? letter
        if @guesses.include? letter
            return false
        else
            @guesses += letter
            return true
        end
    else
        if @wrong_guesses.include? letter
            return false
        else 
            @wrong_guesses += letter
            return  true
        end
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
