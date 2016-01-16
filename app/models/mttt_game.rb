class MtttGame < ActiveRecord::Base
  has_many :mttt_moves, dependent: :destroy
  has_and_belongs_to_many :users

  serialize :board, Array
  serialize :player1, Hash
  serialize :player2, Hash
  serialize :current_player, Hash

  after_initialize :set_state

  def set_state
    self.state ||= 'in_progress'
  end

  STATES = %w(in_progess finished)
  OPPONENTS = %w(user friend ai)

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end
  end

  OPPONENTS.each do |opponent|
    define_method("#{opponent}?") do
      self.opponent == opponent
    end
  end

end
