class CreateJoinTableUserTttGame < ActiveRecord::Migration
  def change
    create_join_table :users, :ttt_games do |t|
      # t.index [:user_id, :ttt_game_id]
      # t.index [:ttt_game_id, :user_id]
    end
  end
end
