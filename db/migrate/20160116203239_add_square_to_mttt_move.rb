class AddSquareToMtttMove < ActiveRecord::Migration
  def change
    add_column :mttt_moves, :square, :string
  end
end
