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
                error_message = game_input.message(:input_error, 1, cols)
                expect(game_input).to receive(:puts).with(error_message).once
                game_input.player_input(1, cols)
            end            
        end

        context 'when given an invalid input twice, then valid input' do
            before do
                valid_input = '3'
                allow(game_input).to receive(:gets).and_return('13', '99', valid_input)
            end

            it 'displays error message twice' do
                cols = game_input.instance_variable_get(:@cols)
                error_message = game_input.message(:input_error, 1, cols)
                expect(game_input).to receive(:puts).with(error_message).twice
                game_input.player_input(1, cols)
            end            
        end

        context 'when given a valid input' do
            before do
                valid_input = '3'
                allow(game_input).to receive(:gets).and_return(valid_input)
            end

            it 'not display error message' do
                cols = game_input.instance_variable_get(:@cols)
                error_message = game_input.message(:input_error, '1', cols)
                expect(game_input).not_to receive(:puts).with(error_message)
                game_input.player_input(1, cols)
            end            
        end
    end

    describe '#validate_input' do
        # query method, test return value
        subject(:game_valid) { described_class.new }
        context 'when given an invalid value' do
            it 'returns nil' do
                invalid_value = 13
                expect(game_valid.validate_input(invalid_value, 1, 7)).to be_nil
            end
        end

        context 'when given a valid value' do
            it 'returns the value itself' do
                valid_value = 3
                expect(game_valid.validate_input(valid_value, 1, 7)).to eq(valid_value)
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
                expect(game_drop.board[5][3]).to eq(1)
            end
        end

        context 'when a peg is dropped on a partially filled column' do
            before do
                game_drop.board[5][3] = 1
                game_drop.board[4][3] = 2
                game_drop.board[3][3] = 1
            end
            it 'puts the player number atop the other numbers' do
                column = 4
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
                column = 4
                player = 1
                error_message = game_drop.message(:column_is_full, column)
                expect(game_drop).to receive(:puts).with(error_message)
                game_drop.drop_peg(player, column)
            end
        end
    end

end
