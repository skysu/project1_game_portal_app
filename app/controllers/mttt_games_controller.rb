class MtttGamesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_mttt_game, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @mttt_game = MtttGame.new
    @users = User.players.all_except(current_user)
  end

  def create
    # @mttt_game = TttGame.create(ttt_game_params.merge({ player2: { id: ttt_game_params[:player2].to_i, symbol: nil } }))
    @mttt_game = MtttGame.new
    @mttt_game.player1[:id] = current_user.id
    @mttt_game.player2[:id] = mttt_game_params[:player2].to_i
    @mttt_game.opponent = mttt_game_params[:opponent]
    @mttt_game.save

    @mttt_game.users << User.find(@mttt_game.player1[:id])
    @mttt_game.users << User.find(@mttt_game.player2[:id])

    @mttt_game.set_players_symbols
    @mttt_game.set_initial_current_player
    @mttt_game.set_current_turn_message

    if user_is_current_player?
      redirect_to edit_mttt_game_path(@mttt_game) and return
    else
      redirect_to mttt_game_path(@mttt_game) and return
    end
  end

  def show
    unless @mttt_game.finished?
      # if @mttt_game.ai_playing?
      #   square = rand(9)
      #   move = MtttMove.create(player: @mttt_game.current_player,
      #                         square: square)
      #   @mttt_game.turn(move)
      # end

      if user_is_current_player?
        redirect_to edit_mttt_game_path(@mttt_game) and return
      end
    end
  end

  def edit
    if @mttt_game.finished? || !user_is_current_player?
        redirect_to mttt_game_path(@mttt_game) and return
    end
  end

  def update
    unless user_is_current_player?
      redirect_to edit_mttt_game_path(@mttt_game) and return
    end

    move = MtttMove.create(player: @mttt_game.current_player,
                          square: [params[:square_i], params[:square_j]])
    @mttt_game.turn(move)

    # if @ttt_game.ai_playing?
    #   ai = TttMinMax.new(@ttt_game.player2[:symbol])
    #   square = ai.choose_square(@ttt_game.board)
    #   move = TttMove.create(player: @ttt_game.current_player,
    #                         square: square)
    #   @ttt_game.turn(move)
    # end

    case @mttt_game.state
      when 'in_progress'
        if user_is_current_player?
          redirect_to edit_mttt_game_path(@mttt_game) and return
        else
          redirect_to mttt_game_path(@mttt_game) and return
        end
      when 'finished'
        GameStat.update_game_stat(@mttt_game, 'Movable Tic-Tac-Toe')
        redirect_to mttt_game_path(@mttt_game) and return
      else
        redirect_to edit_mttt_game_path(@mttt_game) and return
    end
  end

  def destroy
  end

  private
  def mttt_game_params
    params.require(:mttt_game).permit(:player2, :opponent)
  end

  def load_mttt_game
    @mttt_game = MtttGame.find(params[:id])
  end

  def user_is_current_player?
    @mttt_game.current_player[:id] == current_user.id
  end
end
