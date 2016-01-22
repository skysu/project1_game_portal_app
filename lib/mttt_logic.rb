module MtttLogic

  ################ FROM TTTGAME ################

  def turn(move)
    unless self.finished?
      self.mttt_moves << move
      case self.move_state

      when 'picking_up'
        pick_up_piece(move.square)
        add_to_current_player_pieces(1)
        message = if self.friend_playing?
                    "#{current_player_display_name}, choose a square\nto replace your piece"
                  else
                    "Choose a square\nto replace your piece"
                  end

        self.update(move_state: 'replacing', message: message)

      when 'replacing'
        place_piece(move.square, move.player[:symbol])
        add_to_current_player_pieces(-1)
        if self.has_won?(move.player[:symbol], self.board)
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
          message = if self.friend_playing?
                      "#{current_player_display_name},\nchoose a piece to pick up"
                    else
                      "Choose a piece to pick up"
                    end
          self.update(move_state: 'picking_up', message: message)
        end

      when 'normal'
        place_piece(move.square, move.player[:symbol])
        add_to_current_player_pieces(-1)
        if self.has_won?(move.player[:symbol], self.board)
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
            message = if self.friend_playing?
                        "#{current_player_display_name},\nchoose a piece to pick up"
                      else
                        "Choose a piece to pick up"
                      end
            self.update(move_state: 'picking_up', message: message)
          else
            self.update(state: 'in_progress', message: "#{current_player_display_name}'s Turn")
          end
        end
      end
    end
  end

  ################ METHODS ################

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
  end

  def pick_up_piece(square)
    self.board[square[0]][square[1]] = nil
  end

  def add_to_current_player_pieces(pieces)
    self.current_player[:pieces] += pieces
    self.save
    update_player_with_current_player
  end

  def update_player_with_current_player
    if self.current_player[:symbol] == self.player1[:symbol]
      self.update(player1: self.current_player)
    else
      self.update(player2: self.current_player)
    end
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