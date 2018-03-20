class AddGeocoderToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :geocoder_string, :string
  end
end
