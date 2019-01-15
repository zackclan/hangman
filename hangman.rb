require 'io/console'
require 'yaml'


class Game
    attr_accessor :win
    attr_accessor :turn_count
    attr_accessor :word
    attr_accessor :start_condition
    attr_accessor :guess_array
    attr_accessor :guessed_letters
    attr_accessor :check_word
    def initialize
        @guess_array = []
        @check_word = []
        @turn_count = 0
        @guessed_letters = []
        @win = false
        @start_condition = ''
    end
    
    
    def word_generator
      @total_words = []
      File.open("5desk.txt", "r") do |f|
        f.each_line do |line|
            if line.length.between?(7,15)
              @total_words << line 
            end
        end
      end
      @word = @total_words[rand(0..@total_words.length)].downcase.split('')
      @word = @word[0..@word.length - 3]
      @check_word = @word.dup
      @total_words = []
      
    end

    def get_guess_array
        @guess_array = Array.new(@word.length, "_")
    end

    def player_input
        print @guess_array
        puts
        puts
        print  "#{@guessed_letters} are your incorrect guesses"
        puts
        puts
        temp = gets.chomp.downcase
        if temp.length == 1 && temp =~ /[a-z]/ && @guessed_letters.include?(temp) == false && @guess_array.include?(temp) == false
            @guess = temp
        elsif temp == "save"
            save_game
            exit
        else 
            puts "You have either guessed a letter you have already guessed before or entered an incorrect input"
            puts
            puts
            player_input
        end
    end
    def save_game
        File.open("./hangman.yml", "w") { |f| YAML.dump([] <<self, f)}


    end

    def check
        temp_array = @word
        if @word.include?(@guess)
            while temp_array.include?(@guess)
                @guess_array[temp_array.index(@guess)] = @guess
                temp_array[temp_array.index(@guess)] = "*"
            end
        else 
            @turn_count += 1
            @guessed_letters.push(@guess)
        end
    end

    def turn_counter
        puts
        puts "You have #{10 - @turn_count} turns left to guess the word."
        puts

    end

    def check_win
        if @check_word == @guess_array
            puts "**********************************************"
            puts "*******************  #{@guess_array.join('').upcase}  *******************"
            puts "**********************************************"
            puts "congratulations you have guessed the word"
            puts "**********************************************"
            @win = true
        elsif @turn_count == 10
            puts "you have failed."
            exit
        end

    end

    def welcome
        puts "*********************************************************************"
        puts "Welcome to tic tac toe, you have 10 turns to correctly guess the word"
        puts "*********************************************************************"
        puts
        puts "Press N to start a new game, or press L to load a saved game"
        puts "        Type \"Save\" at any time to save your game"
        @start_condition = gets.upcase.chomp
    end
    
end

class Play
    def initialize
        @game = Game.new
    end

    def start_game
        @game.welcome
        if @game.start_condition == "N"
            @game.word_generator
            @game.get_guess_array
            print @game.word.join('')
            puts
            while @game.win == false && @game.turn_count < 10
                @game.turn_counter
                @game.player_input
                @game.check
                @game.check_win
            end
        elsif @game.start_condition == "L"
            begin
                yaml = YAML.load_file("./hangman.yml")
                @game.guess_array = yaml[0].guess_array
                @game.turn_count = yaml[0].turn_count
                @game.guessed_letters = yaml[0].guessed_letters
                @game.check_word = yaml[0].check_word
                @game.word = yaml[0].word
            end
                while @game.win == false && @game.turn_count < 10
                    @game.turn_counter
                    @game.player_input
                    @game.check
                    @game.check_win
                end             
             

        end

    end

end

a = Play.new
a.start_game




