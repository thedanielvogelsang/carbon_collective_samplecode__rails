class AddZipcodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :zipcode, foreign_key: true
  end
end
