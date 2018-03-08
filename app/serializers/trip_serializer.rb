class TripSerializer < ActiveModel::Serializer
  attributes :id, :user, :trip_name, :mode, :day, :total_mileage, :total_time,
          :co2_produced, :start, :stop

      def user
        object.user.username
      end
      
      def mode
        object.trip_type
      end

      def start
        object.start.strftime('%I:%M:%S %p')
      end

      def stop
        object.stop.strftime('%I:%M:%S %p')
      end


end
