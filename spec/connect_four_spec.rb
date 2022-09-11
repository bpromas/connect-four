require_relative '../lib/connect_four'
require_relative '../lib/text_printer'

describe ConnectFour do
    describe '#initialize' do
        # test not required
    end

    describe '#play' do
        # public script method, test not required
    end

    describe '#player_input' do
        # looping public script, test method behavior
        subject(:game_input) { described_class.new }

        context 'when given an invalid input once, then valid input' do
            before do
                valid_input = '3'
                allow(game_input).to receive(:gets).and_return('13', valid_input)
            end

            it 'displays error message once' do
                cols = game_input.instance_variable_get(:@cols)
                error_message = game_input.message(:input_error, 0, cols-1)
                expect(game_input).to receive(:puts).with(error_message).once
                game_input.player_input(0, cols-1)
            end            
        end

        context 'when given an invalid input twice, then valid input' do
            before do
                valid_input = '3'
                allow(game_input).to receive(:gets).and_return('13', '99', valid_input)
            end

            it 'displays error message twice' do
                cols = game_input.instance_variable_get(:@cols)
                error_message = game_input.message(:input_error, 0, cols-1)
                expect(game_input).to receive(:puts).with(error_message).twice
                game_input.player_input(0, cols-1)
            end            
        end

        context 'when given a valid input' do
            before do
                valid_input = '3'
                allow(game_input).to receive(:gets).and_return(valid_input)
            end

            it 'not display error message' do
                cols = game_input.instance_variable_get(:@cols)
                error_message = game_input.message(:input_error, 0, cols-1)
                expect(game_input).not_to receive(:puts).with(error_message)
                game_input.player_input(0, cols-1)
            end            
        end
    end

    describe '#validate_input' do
        # query method, test return value
        subject(:game_valid) { described_class.new }
        context 'when given an invalid value' do
            it 'returns nil' do
                invalid_value = 13
                expect(game_valid.validate_input(invalid_value, 0, 6)).to be_nil
            end
        end

        context 'when given a valid value' do
            it 'returns the value itself' do
                valid_value = 3
                expect(game_valid.validate_input(valid_value, 0, 6)).to eq(valid_value)
            end
        end
    end

    describe '#drop_peg' do
        subject(:game_drop) { described_class.new }
        context 'when a peg is dropped on an empty column' do
            it 'changes the value at the bottom to the player number' do
                column = 4
                player = 1
                game_drop.drop_peg(player, column)
                expect(game_drop.board[5][4]).to eq(1)
            end
        end

        context 'when a peg is dropped on a partially filled column' do
            before do
                game_drop.board[5][3] = 1
                game_drop.board[4][3] = 2
                game_drop.board[3][3] = 1
            end
            it 'puts the player number atop the other numbers' do
                column = 3
                player = 2
                game_drop.drop_peg(player, column)
                expect(game_drop.board[2][3]).to eq(2)
            end
        end

        context 'when a peg is dropped on a full column' do
            before do
                game_drop.board[5][3] = 1
                game_drop.board[4][3] = 2
                game_drop.board[3][3] = 1
                game_drop.board[2][3] = 2
                game_drop.board[1][3] = 1
                game_drop.board[0][3] = 2
            end
            it 'does not drop a peg and warns the player' do
                column = 3
                player = 1
                error_message = game_drop.message(:column_is_full, column)
                expect(game_drop).to receive(:puts).with(error_message)
                game_drop.drop_peg(player, column)
            end
        end
    end

    describe 'game_over?' do
        subject(:game_over) { described_class.new }

        context 'when there are no connected four' do

            before do
                game_over.board[5][2] = 1
            end
            it 'returns false' do
                expect(game_over.game_over?(2)).to be false
            end
        end
        
        context 'when there are four connected vertically' do
            before do
                game_over.board[5][2] = 1
                game_over.board[4][2] = 1
                game_over.board[3][2] = 1
                game_over.board[2][2] = 1
            end
            it 'returns true' do
                expect(game_over.game_over?(2)).to be true
            end
        end
        
        context 'when there are four connected horizontally' do
            before do
                game_over.board[5][2] = 1
                game_over.board[5][3] = 1
                game_over.board[5][4] = 1
                game_over.board[5][5] = 1
            end
            it 'returns true' do
                expect(game_over.game_over?(5)).to be true
            end
        end

        # LTR diagonal = \
        context 'when there are four connected diagonally LTR' do
            before do
                game_over.board[2][2] = 1
                game_over.board[3][3] = 1
                game_over.board[4][4] = 1
                game_over.board[5][5] = 1
            end
            it 'returns true' do
                expect(game_over.game_over?(5)).to be true
            end
        end
        
        # RTL diagonal = /
        context 'when there are four connected diagonally RTL' do
            before do
                game_over.board[5][2] = 1
                game_over.board[4][3] = 1
                game_over.board[3][4] = 1
                game_over.board[2][5] = 1
            end
            it 'returns true' do
                expect(game_over.game_over?(5)).to be true
            end
        end
    end


end
