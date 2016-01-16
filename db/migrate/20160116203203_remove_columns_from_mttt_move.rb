class RemoveColumnsFromMtttMove < ActiveRecord::Migration
  def change
    remove_column :mttt_moves, :square_i, :integer
    remove_column :mttt_moves, :square_j, :integer
  end
end
