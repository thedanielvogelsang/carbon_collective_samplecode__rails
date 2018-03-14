class User < ApplicationRecord
  has_and_belongs_to_many :friendships,
        class_name: "User",
        join_table:  :friendships,
        foreign_key: :user_id,
        association_foreign_key: :friend_user_id

  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups

  has_many :admins
  has_many :trips

  has_many :electric_bills

  validates :email, presence: true, uniqueness: true
  validate :check_email_format
  validates_uniqueness_of :username, case_sensitive: false


def total_co2_saved
end

def self.create_with_omniauth(auth)
  uid = auth['uid']
  token = auth['credentials'].token
  user = find_or_create_by(uid: uid, provider:  auth['provider'])
  user.password = uid
  user.uid = uid
  user.token = token
  user.email = auth['info'].email
  name = auth['info']['name'].split(' ')
  user.first = name[0]
  user.last = name[1]
  if User.exists?(uid)
    user
  else
    user.save!
    user
  end
end

private
  def check_email_format
    return if errors.key?(:email)
    validates_format_of :email, with: /\A([a-z0-9_\.-]+\@[\da-z\.-]+\.[a-z\.]{2,6})\z/, message: "Address Invalid Format"
  end
end
