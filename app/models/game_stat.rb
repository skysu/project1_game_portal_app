class GameStat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  after_initialize :init
  after_save :set_total

  def self.of_players
    GameStat.all.select do |stat|
      stat.user.player?
    end
  end

  def self.of_ais
    GameStat.all.select do |stat|
      stat.user.ai?
    end
  end

  def init
    self.wins ||= 0
    self.losses ||= 0
    self.draws ||= 0
    set_total
  end

  def set_total
    self.total = self.wins + self.losses + self.draws
  end

  def self.update_game_stat(game_session, game_name)
    if game_session.finished? && game = Game.find_by_name(game_name)
      unless game_session.friend_playing?
        case game_session.winner_id
          when game_session.player1_user.id

            player1_stats = game_session.player1_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player1_stats.wins += 1
            player1_stats.save

            player2_stats = game_session.player2_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player2_stats.losses += 1
            player2_stats.save

          when game_session.player2_user.id

            player2_stats = game_session.player2_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player2_stats.wins += 1
            player2_stats.save

            player1_stats = game_session.player1_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player1_stats.losses += 1
            player1_stats.save

          else

            player1_stats = game_session.player1_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player1_stats.draws += 1
            player1_stats.save

            player2_stats = game_session.player2_user.game_stats.find_or_create_by(game_id: game.id, game_name: game.name)
            player2_stats.draws += 1
            player2_stats.save

        end
      end
    end
  end

end
