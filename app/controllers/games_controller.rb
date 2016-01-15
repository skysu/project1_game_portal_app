class GamesController < ApplicationController
  def index
    @games = Game.all.order(name: :asc)
  end

  def show
    @game = Game.find(params[:id])
  end

end