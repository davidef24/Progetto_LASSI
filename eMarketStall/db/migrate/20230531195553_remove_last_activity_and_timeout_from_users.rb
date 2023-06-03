class RemoveLastActivityAndTimeoutFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :timeout_at, :datetime
  end
end

