require 'mttt_win_checker'

module MtttLogic

  ################ FROM TTTGAME ################

  def turn(move)
    unless self.finished?
      self.mttt_moves << move
      case self.move_state

        when 'picking_up'
          pick_up_piece(move.square)
          self.current_player[:pieces] += 1
          self.save
          update_player_with_current_player
          self.update(move_state: 'replacing', message: "#{self.current_player_user.username}, choose a square to replace your piece")

        when 'replacing'
          place_piece(move.square, move.player[:symbol])
          self.current_player[:pieces] -= 1
          self.save
          update_player_with_current_player
          if MtttWinChecker.new.has_won?(move.player[:symbol], self.board)
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
            self.update(move_state: 'picking_up', message: "#{self.current_player_user.username}, choose a piece to pick up")
          end

        when 'normal'
          place_piece(move.square, move.player[:symbol])
          if MtttWinChecker.new.has_won?(move.player[:symbol], self.board)
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
            self.current_player[:pieces] -= 1
            self.save
            update_player_with_current_player
            self.update(current_player: switch(current_player))

            if self.current_player[:pieces] <= 0
              self.update(move_state: 'picking_up')
            else
              self.set_current_turn_message
              self.update(state: 'in_progress')
            end
          end
      end
    end
  end

  ################ METHODS ################

  def update_player_with_current_player
    if self.current_player[:symbol] == self.player1[:symbol]
      self.update(player1: self.current_player)
    else
      self.update(player2: self.current_player)
    end
  end

  def valid_move?(square)
    (0..8).include?(square) && space_available?(square)
  end

  def space_available?(square)
    self.board[square[0]][square[1]].nil?
  end

  def place_piece(square, piece)
    self.board[square[0]][square[1]] = piece
  end

  def pick_up_piece(square)
    self.board[square[0]][square[1]] = nil
  end

  def draw?
    available_spaces.empty?
  end

  def available_spaces
    available = []
    self.board.flatten.each_index do |i|
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
          squares << [y,x] if valid_square_to_pick_up?([y,x], board)
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