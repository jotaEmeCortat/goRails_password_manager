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

## Encrypting Passwords In The Database

[Active Record Encryption](https://guides.rubyonrails.org/active_record_encryption.html)
is a feature in Rails 7 that allows you to encrypt sensitive data before it is
stored in the database.

```bash
bin/rails db:encryption:init
```

After active record encryption is initialized, you can edit the credentials file
to set the encryption key and salt. The `EDITOR` environment variable is used to
specify the text editor that will be used to edit the credentials file. In this
example, we are using Visual Studio Code with the `--wait` flag, which tells the
editor to wait until the file is closed before returning control to the
terminal.

```bash
EDITOR="code --wait" rails credentials:edit --environment=development
# Adding config/credentials/development.key to store the encryption key: xxxxxxxxxxxxxxxxxxxxxxxxxx

# Save this in a password manager your team can access.

# If you lose the key, no one, including you, can access anything encrypted with it.

#       create  config/credentials/development.key

# Ignoring config/credentials/development.key so it won't end up in Git history:

#       append  .gitignore
```

Add the keys for active record encryption. The `primary_key` is used to encrypt
the data, the `deterministic_key` is used for deterministic encryption, which
allows you to query encrypted data, and the `key_derivation_salt` is used to
derive the encryption keys.

Remember to save and close the credentials file after adding the keys.

```yaml
active_record_encryption:
  primary_key: xxxxxxxxxxxxxxxxxxxxxxxxxx
  deterministic_key: xxxxxxxxxxxxxxxxxxxxxxxxxx
  key_derivation_salt: xxxxxxxxxxxxxxxxxxxxxxxxxx
```

In password model, add `encrypts` to the attributes to enable encryption. Use
`deterministic: true` for the `username` attribute to allow querying.

```ruby
class Password < ApplicationRecord
	# [...]

	encrypts :username, deterministic: true
	encrypts :password
end
```

Now when you create a new password entry, the `username` and `password` will be
encrypted before being stored in the database.

```ruby
rails c
irb(main):001:0> Password.create! url:"twitter.com", username:"whatever", password:"1234"
#   TRANSACTION (0.2ms)  BEGIN
Password Create (0.7ms)  INSERT INTO "passwords" ("url", "username", "password", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"  [["url", "twitter.com"], ["username", "{\"p\":\"ias0eBk0aKU=\",\"h\":{\"iv\":\"QxCz/gH/LYkQTdPa\",\"at\":\"cIerDvLUqKxrBLdznMUISA==\"}}"], ["password", "[FILTERED]"], ["created_at", "2026-05-30 13:47:07.671168"], ["updated_at", "2026-05-30 13:47:07.671168"]]
#   TRANSACTION (1.9ms)  COMMIT
```

## Creating Passwords Through A Join Table

Create simple CRUD actions for the `Password` model. When creating a new
password, associate it with the current user through the `UserPassword` join
table.

Files changed in this section:

- `config/routes.rb`
- `app/controllers/passwords_controller.rb`
- `app/views/passwords/index.html.erb`
- `app/views/passwords/_form.html.erb`
- `app/views/passwords/_password.html.erb`
- `app/views/passwords/new.html.erb`
- `app/views/passwords/show.html.erb`
- `app/models/password.rb`
