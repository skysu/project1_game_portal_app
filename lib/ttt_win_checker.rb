class TttWinChecker

  HORIZONTAL_LINES = [ [0, 1, 2], [3, 4, 5], [6, 7, 8] ]
  VERTICAL_LINES = [ [0, 3, 6], [1, 4, 7], [2, 5, 8] ]
  DIAGONAL_LINES = [ [0, 4, 8], [2, 4, 6] ]
  WINNING_LINES = HORIZONTAL_LINES + VERTICAL_LINES + DIAGONAL_LINES


  def has_won?(symbol, board)
    indices = map_symbol_indices(symbol, board)
    winning_line?(indices)
  end

  def winner(symbol, board)
    has_won?(symbol, board) ? symbol : false
  end

  private

  def map_symbol_indices(symbol, board)
    symbol_indices = []
    board.each_index do |i|
      symbol_indices << i if board[i] == symbol
    end
    symbol_indices
  end

  def winning_line?(indices)
    WINNING_LINES.each do |line|
      return true if indices & line == line
    end
    return false
  end

end