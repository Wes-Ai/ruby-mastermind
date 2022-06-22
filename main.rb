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
  def user_input
    gets.chomp
  end

  def pick_random_colors(amount)
    colors = %w[R B G P]
    random_colors = []
    i = 0
    while i < amount
      random_colors[i] = colors.sample
      i += 1
    end
    p random_colors
    random_colors
  end
end

class Player
  def initialize(name)
    @name = name

  end

  def play

  end

  def select_code

  end

  def give_hint

  end
end

class Computer < Player
  include Logic
  attr_accessor :name
  
  def initialize
    @name = 'CPU'
    @random_code = nil
  end

  def select_code
    pick_random_colors(4)
  end
end

class Human < Player
  def input_code

  end

  def input_hint

  end
end

module Display
  def display_game_board(game_array, feedback_array)
    #TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    tabber = "\t"
    header = tabber + "_______________________________________\n" +
             tabber + "+-------- M A S T E R M I N D --------+\n\n"
    print header
    (0..game_array.length - 1).each do |i|
      print tabber + "          " + game_array[i].join(' ') + '  |  ' + feedback_array[i].join(' ') + "\n"
    end
  end

  def display_selecting_code(name)
    print "#{name} is selecting a random code."
    sleep(0.2)
    print '.'
    sleep(0.2)
    print '.'
    sleep(0.2)
    print "\n"
  end

  def display_welcome
    puts 'Welcome to Wes\' Mastermind!'
  end

  def display_human_choose_name
    puts 'What is your name?'
  end

  def display_colors_available
    puts "There are 4 colors available:\n> " + 'red'.bg_red.black +
         ', ' + 'blue'.bg_blue.black + ', ' + 'green'.bg_green.black +
         ', & ' + 'purple'.bg_magenta.black + '.'
  end

  def display_computer_or_human
    puts 'What is the second players name? Enter "CPU" for a CPU opponent.'
  end

  def display_enter_4_guesses
    puts 'Enter your 4 guesses with a space between:'
  end

  def display_guesser_winner_message
    puts 'Congratulations! The code has been broken!'
  end

  def display_incorrect_input_from_user(invalid_input_array)
    puts "#{invalid_input_array} is not a valid input."
  end
end

class Board
  include Display
  include Logic

  def initialize
    @player1 = nil
    @player2 = nil
    @turn_count = 0
    @game_won = false
    @code_to_break = []
    @guess_array = []
    @feedback_array = []
  end

  def begin_game
    startup_sequence
    display_selecting_code(@player2.name)
    @code_to_break = @player2.select_code
    until @turn_count >= 11 || @game_won
      play_round
      @turn_count += 1
    end
  end

  def play_round
    display_enter_4_guesses
    @guess_array << user_input.upcase.split(' ')
    if check_correct_user_input
      check_guesses
    else
      play_round
    end
  end

  def check_correct_user_input
    #TODOOOOOOOOOOOO def check length, def check type lol
    p @guess_array[@turn_count].length
    @guess_array[@turn_count].each do |guess|
      unless guess == 'R' || guess == 'G' || guess == 'B' || guess == 'P'
        display_incorrect_input_from_user(@guess_array[@turn_count])
        @guess_array.delete_at(@turn_count)
        return false
      end
    end
    true
  end

  def check_guesses
    if @guess_array[@turn_count].eql?(@code_to_break)
      display_guesser_winner_message
      @game_won = true
    else
      build_feedback_array[@turn_count]
      display_game_board(@guess_array, @feedback_array)
    end
  end

  def build_feedback_array
    store_feedback = ''
    loop_count = 0
    temp_specific = check_match_in_specific_position
    temp_any = check_match_in_any_board_position - temp_specific
    until loop_count == 4
      if !temp_specific.zero?
        store_feedback << ' S'
        temp_specific -= 1
      elsif !temp_any.zero?
        store_feedback << ' A'
        temp_any -= 1
      else
        store_feedback << ' O'
      end
      loop_count += 1
    end
    @feedback_array << store_feedback.split(' ')
  end

  def check_match_in_any_board_position
    any_position_match = 0
    temp_guesses = Marshal.load(Marshal.dump(@guess_array[@turn_count]))
    temp_code = Marshal.load(Marshal.dump(@code_to_break))
    for i in 0..@code_to_break.length - 1 do
      for k in 0..temp_code.length - 1 do
        if temp_guesses[i] == temp_code[k]
          # Replaces copies with useless info, so they're not picked
          # up during the next iteration.
          temp_guesses[i] = "Dill#{i}"
          temp_code[k] = "Pickle#{k}"
          any_position_match += 1
          break
        end
      end
    end
    any_position_match
  end

  def check_match_in_specific_position
    specific_position_match = 0
    for i in 0..@code_to_break.length - 1 do
      if @guess_array[@turn_count][i] == @code_to_break[i]
        specific_position_match += 1
      end
    end
    specific_position_match
  end

  def startup_sequence
    display_welcome
    display_colors_available
    assign_players
  end

  def assign_players
    display_human_choose_name
    @player1 = Player.new(user_input)
    display_computer_or_human
    user_decision = user_input
    if user_decision.upcase.eql?('CPU')
      @player2 = Computer.new
    else
      @player2 = Player.new(user_decision)
    end
  end
end

class Piece

end




test = Board.new
test.begin_game
