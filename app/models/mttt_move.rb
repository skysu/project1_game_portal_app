class MtttMove < ActiveRecord::Base
  belongs_to :mttt_game

  serialize :player, Hash
end
