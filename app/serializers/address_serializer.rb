class AddressSerializer < ActiveModel::Serializer
  attributes :id, :full_address, :house, :neighborhood, :county,

  def full_address
    object.address_line1 + ' ' + object.address_line2.to_s + ' ' + object.city.name +
        ', ' + object.region.name
  end
  def neighborhood
    object.neighborhood if object.neighborhood
  end
  def county
    object.county if object.county
  end
end
