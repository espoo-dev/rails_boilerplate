# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(username: 'registered_user1', password: '111', access_level: User.access_levels[:registred])
user2 = User.create(username: 'registered_user2', password: '222', access_level: User.access_levels[:registred])
user3 = User.create(username: 'admin_user1', password: '111', access_level: User.access_levels[:admin])
user4 = User.create(username: 'admin_user2', password: '222', access_level: User.access_levels[:admin])
