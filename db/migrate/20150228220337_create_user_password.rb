class CreateUserPassword < ActiveRecord::Migration
  def change
    create_table :user_passwords do |t|
      add_column :users, :password_digest, :string
    end
  end
end
