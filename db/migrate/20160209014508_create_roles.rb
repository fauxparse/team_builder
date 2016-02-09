class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.belongs_to :team, foreign_key: true
      t.string :name
      t.string :plural

      t.timestamps
    end
  end
end
