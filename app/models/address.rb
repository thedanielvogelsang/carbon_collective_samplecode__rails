class Address < ApplicationRecord
  include AddressHelper



  validates_presence_of :address_line1, :city,
                        :state, :country

  validates_uniqueness_of :address_line1, scope: :neighborhood_id

  has_one :house, :dependent => :destroy

  has_many :users, through: :house
  belongs_to :zipcode
  belongs_to :neighborhood

  before_validation :check_associations

  def check_associations
    create_or_find_regions_and_associations
  end
end
