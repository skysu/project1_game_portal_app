# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rubot = User.create(username: 'RUBOT', email:'rubot@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'ai')
player1 = User.create(username: 'Player1', email:'player1@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'default_player')
player2 = User.create(username: 'Player2', email:'player2@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'default_player')
player3 = User.create(username: 'Player3', email:'player3@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'default_player')
player4 = User.create(username: 'Player4', email:'player4@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'default_player')


ttt = Game.find_or_create_by(name: 'Tic-Tac-Toe', table_name: 'ttt_games', description: 'Also known as noughts and crosses.')
ttt_leaderboard = Leaderboard.create(game_id: ttt.id, game_name: ttt.name)

mttt = Game.find_or_create_by(name: 'Movable Tic-Tac-Toe', table_name: 'mttt_games', description: 'Tic-tac-toe where each player only gets three pieces to play, then has to move them.')
mttt_leaderboard = Leaderboard.create(game_id: mttt.id, game_name: mttt.name)
