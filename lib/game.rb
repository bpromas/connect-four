require_relative 'text_printer'

class Game
    include TextPrinter

    def initialize(rows = 6, cols = 7)
        @rows = rows
        @cols = cols
        @current_player = 0
        @board = Array.new(@rows) { Array.new(@cols, "_") }
    end

    def play
        print_board(@board)
        # player_turn(@current_player)
    end
end