class CreateMtttGames < ActiveRecord::Migration
  def change
    create_table :mttt_games do |t|
      t.string :player1, hash: true, default: { id: nil, symbol: nil, pieces: 3 }
      t.string :player2, hash: true, default: { id: nil, symbol: nil, pieces: 3 }
      t.string :current_player, hash: true
      t.string :board, array: true, default: [ [nil, nil, nil], [nil, nil, nil], [nil, nil, nil] ] 
      t.boolean :is_picking_up, default: false
      t.boolean :is_replacing, default: false
      t.integer :winner_id
      t.boolean :is_draw, default: false
      t.string :state
      t.string :message
      t.string :opponent

      t.timestamps null: false
    end
  end
end
