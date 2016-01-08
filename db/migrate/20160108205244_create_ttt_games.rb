class CreateTttGames < ActiveRecord::Migration
  def change
    create_table :ttt_games do |t|
      t.integer :player1_id
      t.string :player1_symbol
      t.integer :player2_id
      t.string :player2_symbol
      t.integer :current_player_id
      t.string :current_player_symbol
      t.string :players_symbols
      t.string :board, default: [nil,nil,nil,nil,nil,nil,nil,nil,nil]
      t.integer :winner_id
      t.boolean :is_draw, default: false
      t.string :state
      t.string :message

      t.timestamps null: false
    end
  end
end
