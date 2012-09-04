# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Setting up default user Login'
user = User.create! :name => 'ken', :email => 'ken@example.com', :password => 'kenpeter123', :password_confirmation => 'kenpeter123'
puts 'New admin created' << user.name

