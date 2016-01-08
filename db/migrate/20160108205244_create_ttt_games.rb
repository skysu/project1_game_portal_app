class CreateTttGames < ActiveRecord::Migration
  def change
    create_table :ttt_games do |t|
      t.string :player1, default: { id: nil, symbol: nil }
      t.string :player2, default: { id: nil, symbol: nil }
      t.string :current_player, default: { id: nil, symbol: nil }
      t.string :board, default: [nil,nil,nil,nil,nil,nil,nil,nil,nil]
      t.integer :winner_id
      t.boolean :is_draw, default: false
      t.string :state
      t.string :message

      t.timestamps null: false
    end
  end
end
