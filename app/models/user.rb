class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :ttt_games

  validates :username, uniqueness: true,
                       length: { minimun: 3 }

  scope :players, -> { where(role: 'player') }
  scope :all_except, -> (user) { where.not(id: user) }
  scope :rubot, -> { find_by(name: 'RUBOT', role: 'ai') }
  scope :player2, -> { find_by(name: 'Player 2', role: 'default_player') }

end
