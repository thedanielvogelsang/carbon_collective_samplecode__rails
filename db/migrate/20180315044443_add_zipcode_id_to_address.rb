class AddZipcodeIdToAddress < ActiveRecord::Migration[5.1]
  def change
    add_reference :addresses, :zipcode, foreign_key: true
  end
end
