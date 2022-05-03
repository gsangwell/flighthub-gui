# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

BoltOn.create!(name: 'Users', enabled: true)
BoltOn.create!(name: 'Network', enabled: true)
BoltOn.create!(name: 'SSL', enabled: true)
BoltOn.create!(name: 'Console', enabled: true)
BoltOn.create!(name: 'Setup', enabled: true)
