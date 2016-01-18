require 'mttt_win_checker'

module MtttLogic

  ################ FROM TTTGAME ################

  def turn(move)
    unless self.finished?
      self.mttt_moves << move
      case self.move_state

        when 'picking_up'
          pick_up_piece(move.square)
          self.update(move_state: 'replacing', message: "#{current_player_display_name}, choose a square to replace your piece")

        when 'replacing'
          place_piece(move.square, move.player[:symbol])
          if MtttWinChecker.new.has_won?(move.player[:symbol], self.board)
            case self.opponent
              when 'user', 'ai'
                self.update(winner_id: self.current_player[:id])
              when 'friend'
            end
            self.update(state: 'finished', message: "#{current_player_display_name} Wins!")
          elsif draw?
            self.update(state: 'finished', is_draw: true, message: "Game is a draw")
          else
            self.update(current_player: switch(current_player))
            self.update(move_state: 'picking_up', message: "#{current_player_display_name}, choose a piece to pick up")
          end

        when 'normal'
          place_piece(move.square, move.player[:symbol])
          if MtttWinChecker.new.has_won?(move.player[:symbol], self.board)
            case self.opponent
              when 'user', 'ai'
                self.update(winner_id: self.current_player[:id])
              when 'friend'
            end
            self.update(state: 'finished', message: "#{current_player_display_name} Wins!")
          elsif draw?
            self.update(state: 'finished', is_draw: true, message: "Game is a draw")
          else
            self.update(current_player: switch(current_player))

            if self.current_player[:pieces] <= 0
              self.update(move_state: 'picking_up', message: "#{current_player_display_name}, choose a piece to pick up")
            else
              self.update(state: 'in_progress', message: "#{current_player_display_name}'s Turn")
            end
          end
      end
    end
  end

  ################ METHODS ################

  def current_player_display_name
    case self.opponent
      when 'user', 'ai'
        self.current_player_user.username
      when 'friend'
        self.current_player[:symbol].to_s
    end
  end

  def update_player_with_current_player
    if self.current_player[:symbol] == self.player1[:symbol]
      self.update(player1: self.current_player)
    else
      self.update(player2: self.current_player)
    end
  end

  # def update_state(state, message=self.message, is_draw=false)
  #   self.update(state: state, message: message, is_draw: is_draw)
  # end

  # def update_move_state(move_state, message=self.message)
  #   self.update(move_state: state, message: message)
  # end

  # def valid_move?(square)
  #   (0..8).include?(square) && space_available?(square)
  # end

  def space_available?(square)
    self.board[square[0]][square[1]].nil?
  end

  def place_piece(square, piece)
    self.board[square[0]][square[1]] = piece
    self.current_player[:pieces] -= 1
    self.save
    update_player_with_current_player
  end

  def pick_up_piece(square)
    self.board[square[0]][square[1]] = nil
    self.current_player[:pieces] += 1
    self.save
    update_player_with_current_player
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