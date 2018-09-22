class AddCompletedSignupDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :completed_signup_date, :datetime
  end
end
