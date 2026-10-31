class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true
  validates :login, presence: true

  # Finds the user by GitHub id (logins can change, ids can't) and refreshes
  # their profile with the latest data from GitHub.
  def self.from_omniauth(auth)
    find_or_initialize_by(github_id: auth.uid).tap do |user|
      user.update!(
        login: auth.info.nickname,
        name: auth.info.name,
        email: auth.info.email,
        avatar_url: auth.info.image
      )
    end
  end

  def display_name
    name.presence || login
  end
end
