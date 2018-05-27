class AddressBasicSerializer < ActiveModel::Serializer
  attributes :id, :full_address

  def full_address
    object.address_line1 + ' ' + object.address_line2 + ' ' + object.city.name +
        ', ' + object.region.name
  end
end
