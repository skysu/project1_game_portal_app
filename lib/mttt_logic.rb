class MtttLogic

  ################ FROM TTTGAME ################

  def turn(move)
    unless self.finished?
      if self.current_player[:pieces] <= 0
        self.update(state: 'in_progress', message: "Move not valid. Pick again.")
      end
        unless valid_move?(move.square)
          move.destroy
          self.update(state: 'in_progress', message: "Move not valid. Pick again.")
        else
          self.ttt_moves << move
          place_piece(move.square, move.player[:symbol])
          if TttWinChecker.new.winner(move.player[:symbol], self.board)
            case self.opponent
              when 'user', 'ai'
                self.update(winner_id: self.current_player[:id])
                self.update(state: 'finished', message: "#{self.winner_user.username} Wins!")
              when 'friend'
                self.update(state: 'finished', message: "#{self.current_player[:symbol].to_s} Wins!")
            end
          elsif draw?
            self.update(state: 'finished', is_draw: true, message: "Game is a draw")
          else
            self.update(current_player: switch(current_player))
            self.set_current_turn_message
            self.update(state: 'in_progress')
          end
        end
    end
  end

  ################ METHODS ################

  def valid_move?(square)
    (0..8).include?(square) && space_available?(square)
  end

  def space_available?(square)
    self.board[square].nil?
  end

  def place_piece(square, piece)
    self.board[square] = piece
  end

  def draw?
    available_spaces.empty?
  end

  def available_spaces
    available = []
    self.board.each_index do |i|
      available << i if self.board[i].nil?
    end
    available
  end

  def switch(player)
    player == self.player1 ? self.player2 : self.player1
  end

  ################ MTTT_METHODS ################

  def valid_square_to_pick_up?(square, board)
    (-1..1).each do |ky|
      if (0..2).include?(square[0]+ky)
        (-1..1).each do |kx|
          if (0..2).include?(square[1]+kx)
            return true unless board[square[0]+ky][square[1]+kx] || [square[0]+ky, square[1]+kx] == square
          end
        end
      end
    end
    return false
  end

  def valid_squares_to_pick_up(symbol, board)
    squares = []
    board.each_with_index do |row, y|
      row.each_with_index do |square, x|
        if board[y][x] == symbol
          squares << [y,x] if valid_square?([y,x], board)
        end
      end
    end
    return squares
  end

  def valid_squares_to_replace(square, board)
    squares = []
    (-1..1).each do |ky|
      if (0..2).include?(square[0]+ky)
        (-1..1).each do |kx|
          if (0..2).include?(square[1]+kx)
            squares << [square[0]+ky, square[1]+kx] unless board[square[0]+ky][square[1]+kx] || [square[0]+ky, square[1]+kx] == square
          end
        end
      end
    end
    return squares
  end

end