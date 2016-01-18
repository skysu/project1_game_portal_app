module MtttConversion

  def board_to_2d(board_1d)
    board_2d = []
    row = []
    board_1d.each_with_index do |square, i|
      row << square
      if (i + 1) % 3 == 0
        board_2d << row
        row = []
      end
    end
    return board_2d
  end

  def square_to_2d(square_1d)
    row = square_1d % 3
    column = square_1d - (row * 3)
    [row, column]
  end

  def board_to_1d(board_2d)
    board.flatten
  end

end