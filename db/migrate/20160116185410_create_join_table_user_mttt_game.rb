class CreateJoinTableUserMtttGame < ActiveRecord::Migration
  def change
    create_join_table :users, :mttt_games do |t|
      # t.index [:user_id, :mttt_game_id]
      # t.index [:mttt_game_id, :user_id]
    end
  end
end
