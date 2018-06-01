class AddParentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :parent_id, :integer, foreign_key: true
  end
end
