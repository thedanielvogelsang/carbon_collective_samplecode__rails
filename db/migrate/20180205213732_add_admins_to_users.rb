class AddAdminsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :admin, foreign_key: true
  end
end
