module TripHelper
    COEF = {
      'neutral' => 0,
      'public_transit' => 0.4,
      'mo_ped' => 0.6,
      'electric_car' => 0.8,
      'car'     => 1,
      'airplane'=> 1.4,
    }

    CONV = 411 / 453.592

    def distance loc1, loc2
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000               # Radius in meters

      loc1 = loc1.map{|n| n.to_f}
      loc2 = loc2.map{|n| n.to_f}

      dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

      lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      m = rm * c # Delta in meters
      mi = (m / 1000 * 0.621371).round(3)
    end

    def length_miles(array)
      distance array[0], array[-1]
    end

    def length_time(start, stop)
      start = Time.parse(start.to_s)
      stop ? nil : stop = Time.now
      org = ((stop - start) / 3600)
      hours = org.floor
      minutes = ((org - hours) * 60).floor
      seconds = ((((org - hours) * 60) - minutes) * 60).floor
      "#{hours} hours : #{minutes} minutes : #{seconds} sec"
    end

    def co2produced(type, array)
      length_miles(array) * CONV * COEF[type]
    end

end
