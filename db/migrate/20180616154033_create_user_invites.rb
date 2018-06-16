class CreateUserInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :user_invites do |t|
      t.integer :user_id
      t.integer :invite_id

      t.timestamps
    end

    add_index(:user_invites, [:user_id, :invite_id], :unique => true)
    add_index(:user_invites, [:invite_id, :user_id], :unique => true)
  end
end
