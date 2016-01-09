# Needed here?
require 'TttLogic.rb'

class TttGamesController < ApplicationController

  before_action :load_ttt_game, only: [:show, :edit, :update, :delete]

  def new
    @ttt_game = TttGame.new
  end

  def create
    @ttt_game = TttGame.create(ttt_game_params)
    @ttt_game.set_player1_id
             .set_players_symbols
             .set_first_player
    # @ttt_game.set_up
    # redirect to games page?
    redirect_to ttt_game_path(@ttt_game)
  end

  def show
    # include logic in show.html.erb to determine which partial to load
  end

  def edit
  end

  def update
    @ttt_logic = TttLogic.new(@ttt_game, TttWinChecker.new)
    @current_symbol = case @ttt_game.current_player_id
                        when @ttt_game.player1_id then @ttt_game.player1_symbol
                        when @ttt_game.player2_id then @ttt_game.player2_symbol
                      end
    @ttt_move = @ttt_game.moves.create(player_id: @ttt_game.current_player_id,
                                          square: params[:square],
                                          symbol: @current_symbol)
    @ttt_game = @ttt_logic.turn(@ttt_move)

    case @ttt_game.state
      when :error
        redirect_to edit_ttt_game_path(@ttt_game)
        return
      when :next
        if @ttt_game.current_player_id = current_user.id
          redirect_to edit_ttt_game_path(@ttt_game)
          return
        else
          redirect_to ttt_game_path(@ttt_game)
          return
        end
      when :finished
        redirect_to ttt_game_path(@ttt_game)
    end
  end

  private
  def ttt_game_params
    params.require(:ttt_game).permit(:player2_id)
  end

  def load_ttt_game
    @ttt_game = TttGame.find(params[:id])
  end

  def accept_ttt_game
    @ttt_game.is_accepted = true
  end

end


<%= link_to image_tag("#{@symbol}-red.png"), {controller: 'ttt_games', action: 'update', square: 0}, method: :put %>