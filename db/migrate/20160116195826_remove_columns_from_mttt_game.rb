class RemoveColumnsFromMtttGame < ActiveRecord::Migration
  def change
    remove_column :mttt_games, :is_picking_up, :boolean
    remove_column :mttt_games, :is_replacing, :boolean
  end
end
