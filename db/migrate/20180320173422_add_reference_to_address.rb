class AddReferenceToAddress < ActiveRecord::Migration[5.1]
  def change
    add_reference :addresses, :neighborhood, foreign_key: true
  end
end
