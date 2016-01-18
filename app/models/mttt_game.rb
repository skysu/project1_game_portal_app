require 'mttt_logic'

class MtttGame < ActiveRecord::Base
  include MtttLogic

  has_many :mttt_moves, dependent: :destroy
  has_and_belongs_to_many :users

  serialize :board, Array
  serialize :player1, Hash
  serialize :player2, Hash
  serialize :current_player, Hash

  after_initialize :set_state, :set_move_state

  scope :in_progress, -> { where(state: 'in_progress') }
  scope :finished, -> { where(state: 'finished') }

  scope :scorable, -> { where(opponent: ['user', 'ai']) }
  scope :opponent_user, -> { where(opponent: 'user') }
  scope :opponent_friend, -> { where(opponent: 'friend') }
  scope :opponent_ai, -> { where(opponent: 'ai') }
  
  scope :recent_first, -> { order(updated_at: :desc) }

  STATES = %w(in_progess finished)
  MOVE_STATES = %w(normal picking_up replacing)
  OPPONENTS = %w(user friend ai)

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end
  end

  MOVE_STATES.each do |move_state|
    define_method("#{move_state}?") do
      self.move_state == move_state
    end
  end

  OPPONENTS.each do |opponent|
    define_method("#{opponent}_playing?") do
      self.opponent == opponent
    end
  end

  def set_state
    self.state ||= 'in_progress'
  end

  def set_move_state
    self.move_state ||= 'normal'
  end

  def set_players_symbols
    symbols = [:o, :x].shuffle!
    self.player1[:symbol] = symbols.first
    self.player2[:symbol] = symbols.last
    self.save
  end

  def set_initial_current_player
    self.current_player = [self.player1, self.player2].sample
    self.save
  end

  def set_current_turn_message
    self.update(message: "#{self.current_player_display_name}'s Turn")
  end

  def player1_user
    if self.users.exists?(self.player1[:id])
      self.users.find(self.player1[:id])
    else
      User.player1
    end
  end

  def player2_user
    if self.users.exists?(self.player2[:id])
      self.users.find(self.player2[:id])
    else
      User.player2
    end
  end

  def current_player_user
    self.users.find(self.current_player[:id])
  end

  def winner_user
    self.users.find(self.winner_id) if self.winner_id
  end


end
