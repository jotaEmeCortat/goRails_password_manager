# Build a Password Manager with Rails 7

[https://gorails.com/series/password-manager-with-rails-7](https://gorails.com/series/password-manager-with-rails-7)

## Designing Database Models for a Password Manager

Create a new Rails application with PostgreSQL as the database and Tailwind CSS
for styling. Then, add Devise for user authentication. After installing devise,
configure some manual setup.

```bash
rails _7.0.5_ new password_manager -d postgresql --css tailwind
bundle add devise
rails generate devise:install
```

Before generating the `User` model with Devise, create the database. With
_SQLite_, the database file is created automatically on first connection. With
_PostgreSQL_, the database must exist ahead of time, so run `rails db:create`
first.

```bash
rails db:create
rails g devise User
rails db:migrate
```

Create a `Password` model to store the URL, username, and password for each
entry in the password manager.

```bash
rails g model Password url username password
```

```bash
rails g model UserPassword user:references password:references
```

Set up the associations to connect the models.

`models/user.rb`

```ruby
has_many :user_passwords
has_many :passwords, through: :user_passwords
```

`models/password.rb`

```ruby
has_many :user_passwords
has_many :users, through: :user_passwords
```
