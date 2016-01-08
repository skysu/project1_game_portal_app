class CreateTttMoves < ActiveRecord::Migration
  def change
    create_table :ttt_moves do |t|
      t.references :ttt_game, index: true, foreign_key: true
      t.integer :player_id
      t.string :square
      t.string :symbol

      t.timestamps null: false
    end
  end
end
