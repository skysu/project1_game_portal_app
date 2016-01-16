class AddMtttGameToMtttMove < ActiveRecord::Migration
  def change
    add_reference :mttt_moves, :mttt_game, index: true, foreign_key: true
  end
end
