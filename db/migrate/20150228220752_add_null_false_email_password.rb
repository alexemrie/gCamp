class AddNullFalseEmailPassword < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
  end
end
