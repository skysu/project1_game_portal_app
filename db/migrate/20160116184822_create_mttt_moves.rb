class CreateMtttMoves < ActiveRecord::Migration
  def change
    create_table :mttt_moves do |t|
      t.string :player, hash: true
      t.integer :square_i
      t.integer :square_j
      t.boolean :is_picking_up, default: false
      t.boolean :is_replacing, default: false

      t.timestamps null: false
    end
  end
end
