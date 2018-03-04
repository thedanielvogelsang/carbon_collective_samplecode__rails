class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :trip_count, :first, :last, :email, :uid,
                  :token, :zipcode, :admins, :current_location,
                  :workplace, :school, :avatar_url

  def current_location
    object.location
  end

  def zipcode
    if object.zipcode_id
      Zipcode.find(object.zipcode_id).zipcode
    end
  end

  def trip_count
    object.trips.count
  end

  def admins
    admins = {}
    Group.joins(:admin)
         .where(:admins => {user_id: object.id})
         .each_with_index{|g,i| admins[i+1] = g.name}
    admins
  end

  def avatar_url
    object.url
  end

end
