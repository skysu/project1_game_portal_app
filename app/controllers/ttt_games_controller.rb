require 'ttt_logic'

class TttGamesController < ApplicationController

  before_action :load_ttt_game, only: [:show, :edit, :update, :delete]

  def index
    @ttt_games = TttGame.all
  end

  def new
    @ttt_game = TttGame.new
    @users = User.all
  end

  def create
    @ttt_game = TttGame.new
    # @ttt_game.set_player1_id
    @ttt_game.player1[:id] = 1
    # @ttt_game.player1[:id] = current_user.id
    @ttt_game.player2[:id] = ttt_game_params[:player2].to_i
    @ttt_game.save

    @ttt_game.users << User.find(@ttt_game.player1[:id])

    # case @ttt_game.mode
    #   when 'user'
    #   when 'ai'
    #   when 'friend'
    @ttt_game.users << User.find(@ttt_game.player2[:id])

    @ttt_game.set_players_symbols
    @ttt_game.set_first_player
    # redirect to games page?

    if user_is_current_player?
      redirect_to edit_ttt_game_path(@ttt_game) and return
    else
      redirect_to ttt_game_path(@ttt_game) and return
    end
  end

  def show
    unless @ttt_game.finished?
      if user_is_current_player?
        redirect_to edit_ttt_game_path(@ttt_game) and return
      end
    end
  end

  def edit
    if user_is_current_player?
      redirect_to edit_ttt_game_path(@ttt_game) and return
    else
      redirect_to ttt_game_path(@ttt_game) and return
    end
  end

  def update
    @ttt_logic = TttLogic.new(@ttt_game, TttWinChecker.new)
    @ttt_move = @ttt_game.ttt_moves.create(player: @ttt_game.current_player,
                                           square: params[:square])
    @ttt_game = @ttt_logic.turn(@ttt_move)
    # pry.byebug



    case @ttt_game.state
      when 'error', 'next'
        if user_is_current_player?
          redirect_to edit_ttt_game_path(@ttt_game) and return
        else
          redirect_to ttt_game_path(@ttt_game) and return
        end
      when 'finished'
        redirect_to ttt_game_path(@ttt_game) and return
    end
  end

  def delete
    @ttt_game.destroy
    redirect_to ttt_games_path
  end

  private
  def ttt_game_params
    params.require(:ttt_game).permit(:player2)
  end

  def load_ttt_game
    @ttt_game = TttGame.find(params[:id])
  end

  # def accept_ttt_game
  #   @ttt_game.is_accepted = true
  # end

  def user_is_current_player?
    true
    # @ttt_game.current_player[:id] == current_user.id
  end

end


# <%= link_to image_tag("#{@symbol}-red.png"), {controller: 'ttt_games', action: 'update', square: 0}, method: :put %>