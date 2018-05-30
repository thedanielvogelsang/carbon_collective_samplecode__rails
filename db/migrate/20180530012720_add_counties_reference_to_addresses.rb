class AddCountiesReferenceToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_reference :addresses, :county, foreign_key: true
  end
end
