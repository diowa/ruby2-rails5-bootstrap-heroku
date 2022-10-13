# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

france = Country.create!(name: 'France')
italy = Country.create!(name: 'Italy')

paris = france.cities.create!(name: 'Paris')
rome = italy.cities.create!(name: 'Rome')

pascal = paris.schools.create!(name: 'B. Pascal')
galilei = rome.schools.create!(name: 'G. Galilei')

pascal.students.create!(name: 'Vincent')
galilei.students.create!(name: 'Mario')
