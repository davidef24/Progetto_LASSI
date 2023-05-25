class ChangeDefaultValueForAttribute < ActiveRecord::Migration[6.1]
  def change
     change_column_default :users, :roles_mask, from: nil, to: 2
  end
end
