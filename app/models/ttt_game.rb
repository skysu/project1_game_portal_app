require 'ttt_logic'
require 'ttt_win_checker'

class TttGame < ActiveRecord::Base
  has_many :ttt_moves, dependent: :destroy
  has_and_belongs_to_many :users

  serialize :board, Array
  serialize :player1, Hash
  serialize :player2, Hash
  serialize :current_player, Hash

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

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end

    # define_method("#{state}!") do
    #   self.update_attribute(state: state)
    # end
  end

  def player1_user
    self.users.find(self.player1[:id])
  end

  def player2_user
    self.users.find(self.player2[:id])
  end

  # def player2_user
  #   case self.mode
  #     when user
  #       self.users.find(self.player2[:id])
  #     when ai
  #       self.users.find(self.player2[:id])
  #     when friend
  #       self.users.find(self.player2[:id])
  #     end
  # end

  def current_player_user
    self.users.find(self.current_player[:id])
  end

  def winner_user
    self.users.find(self.winner_id) if self.winner_id
  end

  def set_player1_id
    self.player1[:id] = current_user.id
    self.save
  end

  def set_players_symbols
    # symbols = [:o, :x].shuffle!
    # players_symbols_hash = { self.player1_id => symbols.first,
    #                     self.player2_id => symbols.last }
    # self.update(players_symbols: players_symbols_hash)
    # self.update(player1_symbol: symbols.first,
    #             player2_symbol: symbols.last)


    symbols = [:o, :x].shuffle!
    self.player1[:symbol] = symbols.first
    self.player2[:symbol] = symbols.last
    self.save
  end

  def set_first_player
    # first_player_id = [self.player1_id, self.player2_id].shuffle!
    # first_player_symbol = symbol_for_player_id(first_player_id)
    # self.update(current_player_id: first_player_id,
    #         current_player_symbol: first_player_symbol)

    self.current_player = [self.player1, self.player2].sample
    self.save
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
