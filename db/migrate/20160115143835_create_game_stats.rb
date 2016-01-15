class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.string :game_name
      t.integer :wins
      t.integer :losses
      t.integer :draws
      t.integer :total

      t.timestamps null: false
    end
  end
end
