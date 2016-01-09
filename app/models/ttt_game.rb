require 'ttt_logic'
require 'ttt_win_checker'

class TttGame < ActiveRecord::Base
  has_many :ttt_moves, dependent: :destroy

  serialize :board, Array
  serialize :player1, Hash
  serialize :player2, Hash
  serialize :current_player, Hash

  # def set_up
  #   set_player1_id
  #   set_players_symbols
  #   set_current_player_id_and_symbol
  # end

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
