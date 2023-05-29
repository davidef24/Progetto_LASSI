class RemoveDefaultFromRolesMaskInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :roles_mask, nil
  end
end
