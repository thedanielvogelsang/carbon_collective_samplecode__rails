class CreateUserGenerations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_generations do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
    add_index(:user_generations, [:parent_id, :child_id], :unique => true)
    add_index(:user_generations, [:child_id, :parent_id], :unique => true)
  end
end
