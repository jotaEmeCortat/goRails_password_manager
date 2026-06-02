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
user = User.create!(email: "user@example.com",  password: "password")
User.create!(email: "user2@example.com", password: "password")
User.create!(email: "user3@example.com", password: "password")


password_one = Password.create!(url: "https://example.com", username: "user@example.com", password: "password")
UserPassword.create!(user: user, password: password_one, role: "owner")

password_two = Password.create!(url: "https://example-2.com", username: "user@example.com", password: "password")
UserPassword.create!(user: user, password: password_two, role: "owner")
