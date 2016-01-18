class TttWinChecker

  WINNING_LINES = [ # Horizontal Lines
                    [0, 1, 2], [3, 4, 5], [6, 7, 8],
                    #Vertical Lines
                    [0, 3, 6], [1, 4, 7], [2, 5, 8],
                    # Diagonal Lines
                    [0, 4, 8], [2, 4, 6] ]


  def winner(symbol, board)
    has_won?(symbol, board) ? symbol : false
  end

  def has_won?(symbol, board)
    indices = map_symbol_indices(symbol, board)
    winning_line?(indices)
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