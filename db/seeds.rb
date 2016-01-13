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