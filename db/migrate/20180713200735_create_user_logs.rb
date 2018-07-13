class CreateUserLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_logs do |t|
      t.time :time
      t.references :user, foreign_key: true
      t.string :action
      t.string :page
      t.string :next_page
      t.string :detail
      t.string :description
    end
  end
end
