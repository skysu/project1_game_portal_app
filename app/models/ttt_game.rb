require 'ttt_logic'
require 'ttt_min_max'

class TttGame < ActiveRecord::Base
  include TttLogic

  has_many :ttt_moves, dependent: :destroy
  has_and_belongs_to_many :users

  serialize :board, Array
  serialize :player1, Hash
  serialize :player2, Hash
  serialize :current_player, Hash

  after_initialize :set_state

  scope :in_progress, -> { where(state: 'in_progress') }
  scope :finished, -> { where(state: 'finished') }

  scope :scorable, -> { where(opponent: ['user', 'ai']) }
  scope :opponent_user, -> { where(opponent: 'user') }
  scope :opponent_friend, -> { where(opponent: 'friend') }
  scope :opponent_ai, -> { where(opponent: 'ai') }
  
  scope :recent_first, -> { order(updated_at: :desc) }


  # validate :limit_users, on: :create

  # def limit_users
  #   if self.users.count >= 2
  # end

  # def set_up
  #   set_player1_id
  #   set_players_symbols
  #   set_current_player_id_and_symbol
  # end

  STATES = %w(in_progress finished)
  OPPONENTS = %w(user friend ai)

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end

    # define_method("#{state}!") do
    #   self.update_attribute(state: state)
    # end
  end

  OPPONENTS.each do |opponent|
    define_method("#{opponent}_playing?") do
      self.opponent == opponent
    end

    # define_method("#{opponent}!") do
    #   self.update_attribute(opponent: opponent)
    # end
  end

  def current_player_is_friend?
    self.current_player[:id] == self.player2[:id]
  end

  # def first_player
  #   self.ttt_moves.first.player
  # end

  

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



  def set_state
    self.state ||= 'in_progress'
  end

  def set_player1_id
    self.player1[:id] = current_user.id
    self.save
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
    message = case self.opponent
      when 'user', 'ai'
        "#{self.current_player_user.username}'s Turn"
      when 'friend'
        if self.current_player[:symbol] == self.player2[:symbol]
          "Friend's Turn"
        else 
          "#{self.current_player_user.username}'s Turn"
        end
    end
    self.update(message: message)
  end

  def symbol_for_player(id)

  end

  private

  # def symbol_for_player_id(player_id)
  #   case player_id
  #     when self.player1_id then self.player1_symbol
  #     when self.player2_id then self.player2_symbol
  #   end
  # end

  # def player_id_of_symbol(symbol)
  #   case symbol
  #     when player1_symbol then player1_id
  #     when player2_symbol then player2_id
  #   end
  # end
end
