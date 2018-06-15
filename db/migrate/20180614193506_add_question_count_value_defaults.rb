class AddQuestionCountValueDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column_default :user_electricity_questions, :q_count, 4
    change_column_default :user_water_questions, :q_count, 4
    change_column_default :user_gas_questions, :q_count, 5
    change_column_default :user_electricity_questions, :a_count, 0
    change_column_default :user_water_questions, :a_count, 0
    change_column_default :user_gas_questions, :a_count, 0
  end
end
