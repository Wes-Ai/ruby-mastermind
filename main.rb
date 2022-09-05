# This allows console text to be colored
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

  def pick_random_code(amount)
    p Array.new(amount) { rand(1...4) }
  end

  def convert_color_to_int(color)
    color.upcase
    case color
    when 'RED', 'R'
      1
    when 'BLUE', 'B'
      2
    when 'GREEN', 'G'
      3
    when 'PURPLE', 'P'
      4
    when 'CYAN', 'C'
      5
    when 'ORANGE', 'O'
      6
    else
      puts 'Error when trying to convert color to int.'
      -1
    end
  end

  def pretty_print_int_to_color(int)
    case color
    when 1
      'Red'
    when 2
      'Blue'
    when 3
      'Green'
    when 4
      'Purple'
    when 5
      'Cyan'
    when 6
      'Orange'
    else
      puts 'Error when trying to convert int to color.'
      -1
    end
  end

  def convert_color_array_to_int(color_code)
    color_code.map {|color| convert_color_to_int(color)}
  end
end

module Display
  def display_game_board(game_array, feedback_array)
    puts puts
    tabber = "\t"
    header = tabber + "_______________________________________\n" +
             tabber + "+-------- M A S T E R M I N D --------+\n\n"
    print header
    (0..game_array.length - 1).each do |i|
      print tabber + "          " + game_array[i].join(' ') + '  |  ' + feedback_array[i].join(' ') + "\n"
    end
    puts puts
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
    puts 'Codebreaker, enter your 4 guesses with a space between:'
  end

  def display_guesser_winner_message
    puts 'Congratulations! The code has been broken!'
  end

  def display_incorrect_input_from_user(invalid_input_array)
    puts "#{invalid_input_array} is not a valid input."
  end

  def display_invalid_input
    puts 'That is invalid input.'
  end

  def display_ask_who_codemaker
    puts 'Enter name of the code maker (blank for CPU):'
  end
end

class Player
  include Logic
  include Display
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def select_code
    puts 'Enter the secret code with 4 colors, for example: "R B G B":'
    # TODO: User input validation on secret code,
    #       refactor user_input_validation to work with any array.
    secret_code = []
    # Convert user_input to number values
    color_code << user_input.upcase.split(' ')
    convert_color_array_to_int(color_code)
    secret_code[0]
  end

  def guess
    display_enter_4_guesses
    p convert_color_array_to_int(user_input.upcase.split(' '))
  end
end

class Computer < Player
  include Logic
  def initialize
    @name = 'CPU'
    @codes = [*1111..4444]
    @current_guess = 1122 
  end

  def select_code
    pick_random_code(4)
  end

  def guess
    puts 'Selecting computer\'s guess...'
    sleep(0.5)
    pick_random_code(4)
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
    @codemaker = nil
  end

  def begin_game
    startup_sequence
    display_selecting_code(@codemaker.name)
    @code_to_break = @codemaker.select_code
    until @turn_count >= 12 || @game_won
      play_round
      @turn_count += 1
    end
  end

  def play_round
    @guess_array << @codebreaker.guess
    if check_correct_user_input
      check_guesses
    else
      play_round
    end
  end

  def check_correct_user_input
    @guess_array[@turn_count].each do |guess|
      unless @guess_array[@turn_count].length == 4
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
          p temp_guesses
          p temp_code
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
    display_ask_who_codemaker
    answer = user_input
    if answer.upcase.eql?('')
      @codemaker = Computer.new
      @codebreaker = Player.new(assign_human)
    else
      @codemaker = Player.new(answer)
      @codebreaker = Computer.new
    end
  end
end

def assign_human
  puts 'You will be guessing against the CPU\'s secret code! What is your name?'
  user_input
end



test = Board.new
test.begin_game
