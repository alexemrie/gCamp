class AddForeignKeys < ActiveRecord::Migration
  def change
     add_foreign_key :memberships, :projects
     add_foreign_key :memberships, :users
     add_foreign_key :tasks, :projects
  end
end
