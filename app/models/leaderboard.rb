class Leaderboard < ActiveRecord::Base
  belongs_to :game

  validates :game_id, uniqueness: true
end
