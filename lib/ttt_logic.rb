class TttLogic
  
  DEFAULT_BOARD = [nil, nil, nil, nil, nil, nil, nil, nil, nil]

  def initialize(game, win_checker)
    @game = game
    @board = game.board
    @win_checker = win_checker
  end

  ################ FROM TTTGAME ################

  def turn(move)
    if place_piece?(move)
      update_board(move)
      check_for_win(move)
    end
    return @game
  end

  ################ METHODS ################

  def place_piece(move)
    if out_of_range?(move.square)
      # Can I do this?
      @game.update(state: :error, message: "Space #{move.square} not valid.")
      return false
    end
    if space_filled?(square)
      @game.update(state: :error, message: "Space #{move.square} already filled.")
      return false
    end
  end

  def update_board(move)
    @board[move.square] = move.symbol
    @game.board = @board
  end

  def check_for_win(move)
    if @win_checker.has_won?(move.symbol, @board)
      winning_player = User.where(id: move.player_id)
      @game.update(state: :finished, winner_id: move.player_id, message: "#{winning_player.name} Wins!")
      # reset()
    elsif board_full?
      @game.update(state: :finished, is_draw: true, message: "Game is a draw")
    else
      update_current_player_id_and_symbol
      @game.update(state: :next, message: nil)
    end
  end

  def update_current_player_id_and_symbol
    @game.current_player_id = case @game.current_player_id
                                when @game.player1_id then @game.player2_id
                                when @game.player2_id then @game.player1_id
                              end
    @game.current_player_symbol = case @game.current_player_id
                                    when @game.player1_id then @game.player1_symbol
                                    when @game.player2_id then @game.player2_symbol
                                  end
    @game.save
  end

  # def reset
  #   @board = DEFUALT_BOARD
  #   @turn = 0
  #   @pieces.rotate!
  #   display_board()
  # end

  ################ PRIVATE METHODS ################

  private

    def out_of_range?(square)
      square > 8 || square < 0
    end

    def space_filled?(square)
      @board[square]
    end

    def board_full?
      @board.all?
    end
  
end