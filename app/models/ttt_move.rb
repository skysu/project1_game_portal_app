class TttMove < ActiveRecord::Base
  belongs_to :ttt_game

  serialize :player, Hash
end
