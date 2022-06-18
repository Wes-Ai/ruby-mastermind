# This allows console teOt to be colored
# Thanks to: https://stackoverflow.com/questions/1489183
class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def orange;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  
  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_orange;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  
  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

module Logic
  def get_user_input
    gets.chomp
  end
end

class Player
  def initialize(name)
    @name = name

  end

  def play

  end

  def choose_code

  end

  def give_hint

  end
end

class Computer < Player
  def initialize; end

  def random_code

  end
end

class Human < Player
  def input_code

  end

  def input_hint

  end
end

module Display
  def display_game_board
    puts '          +---------------+--------------+---------------+'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          |   O  O  O  O  |  O  O  O  O  |  O  O  O  O   |'
    puts '          +---------------+--------------+---------------+'
  end

  def display_selecting_code(name)
    puts "#{name} is selecting a random code..."
  end

  def display_welcome
    puts 'Welcome to Wes\' Mastermind!'
  end

  def display_human_choose_name
    puts 'What is your name?'
  end

  def display_colors_available
    puts "There are 6 colors available:\n> " + 'red'.bg_red.black + 
         ', ' + 'blue'.bg_blue.black + ', ' + 'green'.bg_green.black + 
         ', ' + 'purple'.bg_magenta.black + ', ' + 'cyan'.bg_cyan.black + 
         ' & ' + 'orange'.bg_orange.black + '.'
  end

  def display_computer_or_human
    puts 'What is the second players name? Enter "CPU" for a CPU opponent.'
  end
end

class Board
  include Display
  include Logic

  def initialize
    @player1 = nil
    @player2 = nil
    @decode_colors = { red: 0, blue: 1, green: 2, magenta: 3, cyan: 4, orange: 5 }
  end

  def begin_game
    startup_sequence
  end

  def startup_sequence
    display_welcome
    display_colors_available
    assign_players
  end

  def assign_players
    display_human_choose_name
    @player1 = Player.new(get_user_input)
    display_computer_or_human
    user_decision = get_user_input
    if user_decision.upcase.eql?('CPU')
      @player2 = Computer.new
      p 'chose Cpu'
    else
      @player2 = Player.new(user_decision)
      p 'chose 2nd player'
    end
  end
end

class Piece

end




test = Board.new
test.begin_game
