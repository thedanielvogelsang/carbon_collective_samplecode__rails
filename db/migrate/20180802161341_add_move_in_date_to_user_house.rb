class AddMoveInDateToUserHouse < ActiveRecord::Migration[5.1]
  def change
    add_column :user_houses, :move_in_date, :datetime
  end
end
