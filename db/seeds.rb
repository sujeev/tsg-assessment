# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create( [{ name: "sujeev"}, { name: "sajith"}, { name: "viraj"}])
sports = Sport.create( [ {name: "tennis"}, { name: "basketball"}, { name: "football"}, { name: "vollyball"}])
Court.create( name: "t1", sport: sports.first)
Court.create( name: "t2", sport: sports.first)
Court.create( name: "b1", sport: sports.second)
Court.create( name: "b2", sport: sports.second)
