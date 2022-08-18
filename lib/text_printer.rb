module TextPrinter
    def print_board(board)
        puts "  0    1    2    3    4    5    6"
        board.length.times do |i|
            p board[i]
        end
    end

    def charcode(player)
        player == 0 ? "\u25CB" : "\u25CF"
    end
end
