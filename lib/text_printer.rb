module TextPrinter
    def message(key, *args)
        {
            choose_a_column: "Player #{args[0]} (#{charcode(args[0])}), please choose a column to drop into",
            input_error: "Input error! Pick a number between #{args[0]} and #{args[1]}",
            column_is_full: "Column #{args[0]} is full. Please select a different column.",
            congratulations: "Congratulations Player #{args[0]}! You won this game!"
        }[key]
    end

    def print_board(board)
        puts " 0 1 2 3 4 5 6"
        board.each do |row|
            printed_row = "|"
            row.each do |peg|
                printed_row += charcode(peg) + "|"
            end
            puts printed_row
        end
    end

    def charcode(num)
        case num
        when 0
            "_"
        when 1
            "\u25CB"
        when 2
            "\u25CF"
        end
    end
end
