class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic: true
  encrypts :password

  validates :url, presence: true
  validates :username, presence: true
  validates :password, presence: true

  def shareable_users
    User.excluding(users)
  end

  def shared_user_passwords
    user_passwords.includes(:user).where.not(role: "owner")
  end

  def editable?(user)
    user_password = user_passwords.find_by(user: user)
    user_password.owner? || user_password.editor?
  end

  def shareable?(user)
    user_password = user_passwords.find_by(user: user)
    user_password.owner?
  end
end
