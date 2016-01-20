class GamesController < ApplicationController

  before_action :authenticate_user!

  def index
    @games = Game.all.order(name: :asc)
  end

  def show
    @game = Game.find(params[:id])
  end

  def leaderboard
    @game = Game.find(params[:id])
  end

  def leaderboards
    @games = Game.all.order(name: :asc)
  end

  def games
    user = current_user
    
    if params[:game]

      @in_progress_games, @finished_games, @selected = case params[:game][:table_name]
      when 'mttt_games'
        [user.mttt_games.in_progress_index, user.mttt_games.finished_index, 'mttt_games']

      when 'ttt_games'
        [user.ttt_games.in_progress_index, user.ttt_games.finished_index, 'ttt_games']
      else
        [(user.ttt_games.in_progress_index + user.mttt_games.in_progress_index).sort_by(&:updated_at).reverse, (user.ttt_games.finished_index + user.mttt_games.finished_index).sort_by(&:updated_at).reverse]
      end

    else
      @in_progress_games, @finished_games = [(user.ttt_games.in_progress_index + user.mttt_games.in_progress_index).sort_by(&:updated_at).reverse, (user.ttt_games.finished_index + user.mttt_games.finished_index).sort_by(&:updated_at).reverse]
    end

  end

  private
  def game_params
    params.require(:game).permit(:name, :table_name, :description)
  end

end