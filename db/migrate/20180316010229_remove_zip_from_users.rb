class RemoveZipFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :zipcode_id, :integer
  end
end
