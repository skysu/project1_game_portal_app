class AddOpponentToTttGames < ActiveRecord::Migration
  def change
    add_column :ttt_games, :opponent, :string
  end
end
