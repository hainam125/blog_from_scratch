# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(username: "admin", email: "admin@g.c", password: "11111111", password_confirmation: "11111111", admin: true)
(1..10).each do |n|
  User.create!(username: "member#{n}", email: "member#{n}@g.c", password: "11111111", password_confirmation: "11111111")
end