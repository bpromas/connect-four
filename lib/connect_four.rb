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
        loop do
            last_drop = player_turn(current_player)
            break if game_over?(last_drop)

            toggle_player
        end
        print_board(board)
        puts message(:congratulations, current_player)
    end

    def player_turn(current_player)
        print_board(board)
        puts message(:choose_a_column, current_player)
        col_to_drop = player_input(0, cols-1)
        col_to_drop = player_input(0, cols-1) until drop_peg(current_player, col_to_drop)
        col_to_drop
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
            if row[col] == 0
                successful_drop = true
                row[col] = player
                break
            end
        end
        puts message(:column_is_full, col) unless successful_drop
        successful_drop
    end

    def toggle_player
        @current_player = current_player == 1 ? 2 : 1
    end

    def game_over?(last_drop_col)
        last_drop_row = top_peg_row(last_drop_col)
        # p "last row = #{last_drop_row} // last col = #{last_drop_col}"
        return true if vertical_win(last_drop_row, last_drop_col)
        return true if horizontal_win(last_drop_row)
        return true if diagonal_win(last_drop_row, last_drop_col)
        false
    end

    def top_peg_row(col)
        board.each_with_index do |row, i|
            return i if row[col] != 0
        end
    end

    def vertical_win(row, col)
        win_check = []
        win_check << board[row][col]
        win_check << board[row+1][col] if board[row+1]
        win_check << board[row+2][col] if board[row+2]
        win_check << board[row+3][col] if board[row+3]
        return win_check.all?(current_player) && win_check.size == 4
    end

    def horizontal_win(row)
        results = []
        board[row].each_cons(4) { |arr| results << arr.all?(current_player) }
        results.any?(true)
    end

    def diagonal_win(row, col)
        ltr = ltr_diagonal(row, col)
        results = []
        ltr.each_cons(4) { |arr| results << arr.all?(current_player) }
        return true if results.any?(true)

        rtl = rtl_diagonal(row, col)
        results = []
        rtl.each_cons(4) { |arr| results << arr.all?(current_player) }
        return true if results.any?(true)
        
        return false
    end

    # LTR = \
    def ltr_diagonal(row, col)
        ltr = Array.new(1, board[row][col])
        nav_row = row
        nav_col = col
        while nav_row > 0 && nav_col > 0
            nav_row -= 1
            nav_col -= 1
            ltr.unshift(board[nav_row][nav_col])
        end
        nav_row = row
        nav_col = col
        while nav_row < @rows-1 && nav_col < @cols-1
            nav_row += 1
            nav_col += 1
            ltr.push(board[nav_row][nav_col])
        end
        ltr
    end

    # RTL = /
    def rtl_diagonal(row, col)
        rtl = Array.new(1, board[row][col])
        nav_row = row
        nav_col = col
        while nav_row < @rows-1 && nav_col > 0
            nav_row += 1
            nav_col -= 1
            rtl.unshift(board[nav_row][nav_col])
        end
        nav_row = row
        nav_col = col
        while nav_row > 0 && nav_col < @cols-1
            nav_row -= 1
            nav_col += 1
            rtl.push(board[nav_row][nav_col])
        end
        rtl
    end


end