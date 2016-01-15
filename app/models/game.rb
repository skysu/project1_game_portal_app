class Game < ActiveRecord::Base
  has_many :game_stats
  has_many :users, through: :game_stats
  has_one :leaderboard

  validates :name, uniqueness: true
end