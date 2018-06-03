class AddGenerationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :generation, :integer
  end
end
