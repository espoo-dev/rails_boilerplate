class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 3 }

  enum access_level: { registred: 0, admin: 1 }

  def owner?(entity)
    entity.user == self
  end

  def access_level?
    registred? || admin?
  end

  def fields_string
    "User(id:#{id}, username:#{username}, accesslevel:#{access_level})"
  end
end
