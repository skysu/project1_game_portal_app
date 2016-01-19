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

  class << self
   def in_progress_index
     in_progress.scorable.recent_first
   end

   def finished_index
     finished.scorable.recent_first
   end
  end

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

  def player1_display_name
    player1_user.username
  end

  def player2_user
    if self.users.exists?(self.player2[:id])
      self.users.find(self.player2[:id])
    else
      User.player2
    end
  end

  def player2_display_name
    case self.opponent
      when 'user', 'ai'
        player2_user.username
      when 'friend'
        "#{player1_display_name}'s Friend"
    end
  end

  def current_player_user
    self.users.find(self.current_player[:id])
  end

  def current_player_display_name
    case self.opponent
      when 'user', 'ai'
        self.current_player_user.username
      when 'friend'
        self.current_player[:symbol].to_s
    end
  end

  def winner_user
    self.users.find(self.winner_id) if self.winner_id
  end

  def which_player_edit_view
    if self.mttt_moves.any?
      if current_player[:symbol] == player1[:symbol]
        self.replacing? ? "view-player1-static" : "view-player1"
      else
        self.replacing? ? "view-player2-static" : "view-player2"
      end
    else
      if current_player[:symbol] == player1[:symbol]
        "view-player1-static"
      else
        "view-player2-static"
      end
    end
  end

  def which_player_show_view
    if self.finished?
      if self.is_draw
        if current_player[:symbol] == player1[:symbol]
          "view-player1-draw"
        else
          "view-player2-draw"
        end
      elsif current_player[:symbol] == player1[:symbol]
        "view-player1-static"
      elsif self.ai_playing?
        "view-player2"
      else
        "view-player2-static"
      end
    else
      if current_player[:symbol] == player1[:symbol]
        self.replacing? ? "view-player1-static" : "view-player1"
      else
        self.replacing? ? "view-player2-static" : "view-player2"
      end
    end
  end


end
