class AddMoveStateToMtttGame < ActiveRecord::Migration
  def change
    add_column :mttt_games, :move_state, :string
  end
end
