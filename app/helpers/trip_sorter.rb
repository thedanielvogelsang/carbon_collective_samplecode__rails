module TripSorter
  def user_sort(user_id)
    Trip.where(user_id: user_id).order(:trip_name)
  end
end
