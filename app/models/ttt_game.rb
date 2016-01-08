require 'ttt_logic'

class TttGame < ActiveRecord::Base
  has_many :moves
  serialize :board, Array
  serialize :players_symbols, Hash
end
