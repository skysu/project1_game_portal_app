class TttGamesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_ttt_game, only: [:show, :edit, :update, :destroy]

  def index
    # @ttt_games = TttGame.all
    @in_progress_ttt_games = current_user.ttt_games.scorable.in_progress.recent_first
    # @finished_ttt_games = current_user.ttt_games.where(state: 'finished')
    @finished_ttt_games = current_user.ttt_games.scorable.finished.recent_first
  end

  def new
    @ttt_game = TttGame.new
    @users = User.players.all_except(current_user)
  end

  def create
    # @ttt_game = TttGame.create(ttt_game_params.merge({ player2: { id: ttt_game_params[:player2].to_i, symbol: nil } }))
    @ttt_game = TttGame.new
    @ttt_game.player1[:id] = current_user.id
    @ttt_game.player2[:id] = ttt_game_params[:player2].to_i
    @ttt_game.opponent = ttt_game_params[:opponent]
    @ttt_game.save

    @ttt_game.users << User.find(@ttt_game.player1[:id])
    @ttt_game.users << User.find(@ttt_game.player2[:id])

    @ttt_game.set_players_symbols
    @ttt_game.set_initial_current_player
    @ttt_game.set_current_turn_message

    if user_is_current_player?
      redirect_to edit_ttt_game_path(@ttt_game) and return
    else
      redirect_to ttt_game_path(@ttt_game) and return
    end
  end

  def show
    unless @ttt_game.finished?
      if @ttt_game.ai_playing?
        square = rand(9)
        move = TttMove.create(player: @ttt_game.current_player,
                              square: square)
        @ttt_game.turn(move)
      end

      if user_is_current_player?
        redirect_to edit_ttt_game_path(@ttt_game) and return
      end
    else
      @winning_indices = @ttt_game.winning_indices(@ttt_game.current_player[:symbol], @ttt_game.board)
    end
  end

  def edit
    if @ttt_game.finished? || !user_is_current_player?
        redirect_to ttt_game_path(@ttt_game) and return
    end
  end

  def update
    unless user_is_current_player?
      redirect_to edit_ttt_game_path(@ttt_game) and return
    end

    move = TttMove.create(player: @ttt_game.current_player,
                          square: params[:square])
    @ttt_game.turn(move)

    if @ttt_game.ai_playing?
      ai = TttMinMax.new(@ttt_game.player2[:symbol])
      square = ai.choose_square(@ttt_game.board)
      move = TttMove.create(player: @ttt_game.current_player,
                            square: square)
      @ttt_game.turn(move)
    end

    case @ttt_game.state
      when 'in_progress'
        if user_is_current_player?
          redirect_to edit_ttt_game_path(@ttt_game) and return
        else
          redirect_to ttt_game_path(@ttt_game) and return
        end
      when 'finished'
        GameStat.update_game_stat(@ttt_game, 'Tic-Tac-Toe')
        redirect_to ttt_game_path(@ttt_game) and return
      else
        redirect_to edit_ttt_game_path(@ttt_game) and return
    end
  end

  def destroy
    @ttt_game.destroy
    redirect_to ttt_games_path
  end

  private
  def ttt_game_params
    # params[:ttt_game][:player2] = { id: params[:ttt_game][:player2], symbol: nil }
    params.require(:ttt_game).permit(:opponent, :player2)
  end

  def load_ttt_game
    @ttt_game = TttGame.find(params[:id])
  end

  def user_is_current_player?
    @ttt_game.current_player[:id] == current_user.id
  end

end


# <%= link_to image_tag("#{@symbol}-red.png"), {controller: 'ttt_games', action: 'update', square: 0}, method: :put %>