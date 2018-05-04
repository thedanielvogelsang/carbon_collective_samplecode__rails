class Address < ApplicationRecord
  # Address Helper currently not being used
  include AddressHelper

  validates_presence_of :address_line1, :country, :region, :city

  validates_uniqueness_of :address_line1, scope: :city_id

  has_one :house, :dependent => :destroy

  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :city

  # before_validation :check_associations, on: [:create, :update]

  def check_associations
    create_or_find_regions_and_associations
  end
end
