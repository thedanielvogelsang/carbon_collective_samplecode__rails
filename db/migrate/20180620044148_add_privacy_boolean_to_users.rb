class AddPrivacyBooleanToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :privacy_policy, :boolean
  end
end
