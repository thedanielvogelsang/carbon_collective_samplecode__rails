class AddressSerializer < ActiveModel::Serializer
  attributes :id, :full_address, :house

  def full_address
    object.address_line1 + ' ' + object.address_line2.to_s + ' ' + object.city.name +
        ', ' + object.region.name
  end
end
