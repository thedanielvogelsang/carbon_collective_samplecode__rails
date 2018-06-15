class ChangeQuestionCompletionColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_electricity_questions, :completion
    add_column :user_electricity_questions, :completed, :boolean, :default => false
    remove_column :user_water_questions, :completion
    add_column :user_water_questions, :completed, :boolean, :default => false
    remove_column :user_gas_questions, :completion
    add_column :user_gas_questions, :completed, :boolean, :default => false
  end
end
