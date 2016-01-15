class GamesController < ApplicationController
  def index
    @games = Game.all.order(name: :asc)
  end

end