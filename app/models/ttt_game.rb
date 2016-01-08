class TttGame < ActiveRecord::Base
  serialize :board, Array
  serialize :players_symbols, Hash
end
