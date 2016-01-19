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
    # binding.pry
    user = current_user
    
    @in_progress_games, @finished_games = case params[:game]
    when 'mttt_games'
      [user.mttt_games.in_progress_index, user.mttt_games.finished_index]

    when 'ttt_games'
      [user.ttt_games.in_progress_index, user.ttt_games.finished_index]
    else
      [(user.ttt_games.in_progress_index + user.mttt_games.in_progress_index).sort_by(&:updated_at).reverse, (user.ttt_games.finished_index + user.mttt_games.finished_index).sort_by(&:updated_at).reverse]
    end

  end

end