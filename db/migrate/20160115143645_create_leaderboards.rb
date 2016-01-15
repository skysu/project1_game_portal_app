class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.references :game, index: true, foreign_key: true
      t.string :game_name

      t.timestamps null: false
    end
  end
end
