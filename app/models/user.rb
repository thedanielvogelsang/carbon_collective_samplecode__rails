class User < ApplicationRecord
  attr_accessor :confirm_password
  include UserHelper
  include UserElectricityHelper
  include UserWaterHelper
  include UserGasHelper
  include UserCarbonHelper

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

  has_many :user_generations, :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => "User",  optional: true
  has_many :children, :through => :user_generations, :source => :child
  # has_many :user_addresses

  has_many :user_houses, dependent: :destroy
  has_many :houses, through: :user_houses
  has_many :addresses, through: :houses
  has_many :cities, through: :addresses
  has_many :regions, through: :cities
  has_many :countries, through: :regions

  has_many :user_electricity_rankings, dependent: :destroy
  has_many :user_water_rankings, dependent: :destroy
  has_many :user_gas_rankings, dependent: :destroy
  has_many :user_carbon_rankings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :generation, presence: true
  validate :check_email_format

  before_create :add_zeros,
                :add_confirm_token,
                :add_invite_token

  # after_create :set_default_ranks

def self.create_with_omniauth(auth)
  uid = auth['uid']
  token = auth['credentials'].token
  user = find_or_create_by(uid: uid, provider:  auth['provider'])
  user.password = uid
  user.uid = uid
  user.token = token
  user.url = auth['info']['image']
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

def bills
  self.houses.map{|h| h.bills}.flatten
end

def electric_bills
  self.houses.map{|h| h.electric_bills}.flatten
end
def water_bills
  self.houses.map{|h| h.water_bills}.flatten
end
def gas_bills
  self.houses.map{|h| h.heat_bills}.flatten
end

def email_activate
  self.email_confirmed = true
  self.confirm_token = nil
  self.save!(:validate => false)
end

private
  def check_email_format
    return if errors.key?(:email)
    validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "Address Invalid Format"
  end

# used upon initial creation only
  def add_zeros
    self.total_kwhs_logged = 0
    self.total_electricitybill_days_logged = 0
    self.total_electricity_savings = 0
    self.total_gallons_logged = 0
    self.total_waterbill_days_logged = 0
    self.total_water_savings = 0
    self.total_therms_logged = 0
    self.total_heatbill_days_logged = 0
    self.total_gas_savings = 0
    self.total_carbon_savings = 0
    self.total_pounds_logged = 0
  end

  def add_confirm_token
    if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def add_invite_token
    if self.invite_token.blank?
      self.invite_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
