class AddEmailToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :email, :string
  end
end
