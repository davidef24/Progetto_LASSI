class RemoveLastActivityAtFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :last_activity_at
  end
end
