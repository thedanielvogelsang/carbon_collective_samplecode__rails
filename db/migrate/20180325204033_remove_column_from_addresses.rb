class RemoveColumnFromAddresses < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :geocoder_string, :string
  end
end
