class AddAcceptedDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :accepted_date, :datetime
  end
end
