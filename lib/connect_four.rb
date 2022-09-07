require_relative 'text_printer'

class ConnectFour
    include TextPrinter

    attr_reader :rows, :cols
    attr_accessor :current_player, :board

    def initialize(rows = 6, cols = 7)
        @rows = rows
        @cols = cols
        @current_player = 1
        @board = Array.new(@rows) { Array.new(@cols, 0) }
    end

    def play
        player_turn(current_player) until game_over?
    end

    def player_turn(current_player)
        print_board(board)
        puts message(:choose_a_column, current_player)
        col_to_drop = player_input(1, cols)
        col_to_drop = player_input(1, cols) until drop_peg(current_player, col_to_drop)
        toggle_player
    end

    def player_input(min, max)
        loop do
            input = gets.chomp
            validated_input = validate_input(input.to_i, min, max) if input.match?(/^\d+$/)
            return validated_input if validated_input
            puts message(:input_error, min, max)
        end
    end

    def validate_input(value, min, max)
        return value if value.between?(min, max)
    end

    def drop_peg(player, col)
        successful_drop = false
        board.reverse_each do |row|
            if row[col-1] == 0
                successful_drop = true
                row[col-1] = player
                break
            end
        end
        puts message(:column_is_full, col)
        successful_drop
    end

    def toggle_player
        @current_player = current_player == 1 ? 2 : 1
    end

    def game_over?
        false
    end
end