class CreateUserRequestAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :user_request_areas do |t|
      t.references :area, polymorphic: true, index: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
