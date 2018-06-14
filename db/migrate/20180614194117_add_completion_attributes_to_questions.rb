class AddCompletionAttributesToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :user_electricity_questions, :completion, :boolean, :default => false
    add_column :user_water_questions, :completion, :boolean, :default => false
    add_column :user_gas_questions, :completion, :boolean, :default => false
    add_column :user_electricity_questions, :completion_percentage, :float
    add_column :user_water_questions, :completion_percentage, :float
    add_column :user_gas_questions, :completion_percentage, :float
  end
end
