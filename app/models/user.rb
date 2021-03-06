class User < ApplicationRecord
  include UserHelper
  include UserElectricityHelper
  include UserWaterHelper
  include UserGasHelper
  include UserCarbonHelper

  extend FriendlyId

  has_secure_password
  attr_accessor :confirm_password

  has_and_belongs_to_many :friendships,
        class_name: "User",
        join_table:  :friendships,
        foreign_key: :user_id,
        association_foreign_key: :friend_user_id

  has_and_belongs_to_many :user_invites,
        class_name: "User",
        join_table: :user_invites,
        foreign_key: :user_id,
        association_foreign_key: :invite_id,
        dependent: :destroy

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

  has_many :user_electric_bills
  has_many :user_heat_bills
  has_many :user_water_bills

  has_many :user_electricity_rankings, dependent: :destroy
  has_many :user_water_rankings, dependent: :destroy
  has_many :user_gas_rankings, dependent: :destroy
  has_many :user_carbon_rankings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :generation, presence: true
  validate :check_email_format

  has_many :user_electricity_questions, dependent: :destroy
  has_many :user_water_questions, dependent: :destroy
  has_many :user_gas_questions, dependent: :destroy

  has_many :user_logs, dependent: :destroy
  has_many :user_request_areas, dependent: :destroy

  has_many :user_invites, :foreign_key => "invite_id", :dependent => :destroy

  before_create :add_zeros,
                :add_confirm_token,
                :add_invite_token,
                :set_avg_login_time,
                :create_filename

  after_create :write_file

  friendly_id :email, use: [:slugged, :history]
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
    all_ = []
    all_ << electric_bills
    all_ << water_bills
    all_ << heat_bills
    return all_.flatten
  end

  def electric_bills
    ElectricBill.joins(:user_electric_bills)
                .where(:user_electric_bills => {user_id: id})
  end
  def water_bills
    WaterBill.joins(:user_water_bills)
              .where(:user_water_bills => {user_id: id})
  end
  def heat_bills
    HeatBill.joins(:user_heat_bills)
            .where(:user_heat_bills => {user_id: id})
  end

  def email_activate
    self.email_confirmed = true
    self.accepted_date = DateTime.now
    self.save!(:validate => false)
  end

  def remove_token
    self.confirm_token = nil
    self.save!(:validate => false)
  end

  def complete_signup
    self.completed_signup_date = DateTime.now
    UserMailer.invite_signup_successful
    self.save!(:validate => false)
  end

  def update_login
    self.last_login = DateTime.now
    self.save
  end

  def calc_avg
    span = DateTime.now - last_login.to_datetime
    val = avg_time_btw_logins * total_logins
    self.total_logins += 1
    self.avg_time_btw_logins = (span + val) / self.total_logins
    self.save
  end

  def force_zeros
    add_zeros
    self.save
  end

  def completed_signup?
    self.completed_signup_date ? true : false
  end

  def clear_account
    self.attributes.except('id', 'email', 'generation', 'created_at', 'updated_at').each do |att|
      self[att[0]] = nil
    end
    self.password = 'placeholder'
    self.invite_max = 3
    clear_associations
    delete_file
    self.save
  end

  def re_calculate_bill_history(original)
    mid = UserHouse.find_by(house_id: household.id, user_id: id).move_in_date
    re_calculate_electricity_history(original, mid)
    re_calculate_gas_history(original, mid)
    re_calculate_water_history(original, mid)
    self.save
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

    def set_avg_login_time
      self.total_logins = 0
      self.avg_time_btw_logins = 0
    end

    def create_filename
      self.filename = self.email + SecureRandom.urlsafe_base64.to_s
    end

    def clear_associations
      self.friendships.delete_all
      self.user_invites.delete_all
      self.user_houses.delete_all
      clear_ranks
      add_zeros
      add_confirm_token
      add_invite_token
      set_avg_login_time
      create_filename
    end

    def clear_ranks
      self.user_carbon_rankings.delete_all
      self.user_electricity_rankings.delete_all
      self.user_water_rankings.delete_all
      self.user_gas_rankings.delete_all
    end

    def delete_file
      UserLogHelper.user_deletes_account(self.id)
    end

    def write_file
      UserLogHelper.user_created(self.id)
    end

end
