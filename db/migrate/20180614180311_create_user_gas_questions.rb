class CreateUserGasQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_gas_questions do |t|
      t.integer :a_count
      t.integer :q_count
      t.string :quest1
      t.string :quest2
      t.string :quest3
      t.string :quest4
      t.string :quest5
      t.string :quest6
      t.references :house, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
