class AddCapResidenzaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cap_residenza, :string
  end
end
