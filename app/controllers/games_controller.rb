class GamesController < ApplicationController
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
    ttt_games = current_user.ttt_games.scorable
    @in_progress_ttt_games = ttt_games.in_progress.recent_first
    @finished_ttt_games = ttt_games.finished.recent_first

    mttt_games = current_user.mttt_games.scorable
    @in_progress_mttt_games = mttt_games.in_progress.recent_first
    @finished_mttt_games = mttt_games.finished.recent_first

    @in_progress_games = (@in_progress_ttt_games + @in_progress_mttt_games).sort_by(&:updated_at).reverse
    @finished_games = (@finished_ttt_games + @finished_mttt_games).sort_by(&:updated_at).reverse
    # binding.pry

  end

end