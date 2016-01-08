class CreateTttMoves < ActiveRecord::Migration
  def change
    create_table :ttt_moves do |t|
      t.references :ttt_game, index: true, foreign_key: true
      t.string :player, default: { id: nil, symbol: nil }
      t.integer :square

      t.timestamps null: false
    end
  end
end
