class AddNumAndMessageToUserLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :user_logs, :num, :integer
    add_column :user_logs, :msg, :string
  end
end
