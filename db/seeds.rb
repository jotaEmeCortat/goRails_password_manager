# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Clearing database..."
User.destroy_all
Password.destroy_all
UserPassword.destroy_all

puts "Seeding database..."
User.create!(email: "user@example.com",  password: "password")
User.create!(email: "user2@example.com", password: "password")
user = User.first
user.passwords.create!(url: "https://example.com", username: "user@example.com", password: "password")
user.passwords.create!(url: "https://example-2.com", username: "user@example.com", password: "password")
