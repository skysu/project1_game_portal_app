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

end