class Address < ApplicationRecord
  validates_presence_of :address_line1, :city,
                        :state, :country
  include AddressHelper
  validates_uniqueness_of :address_line1, scope: :city
  has_one :house
  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :neighborhood

  before_validation :check_associations

  def check_associations
    create_or_find_regions_and_associations
  end
end
