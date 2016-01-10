# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rubot = User.create(name: 'RUBOT', email:'rubot@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'ai')
player2 = User.create(name: 'Player 2', email:'player2@email.example', password: 'password', created_at: Time.now, updated_at: Time.now, role: 'default_player')
