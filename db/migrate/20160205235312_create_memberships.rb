class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.belongs_to :team, foreign_key: { on_delete: :cascade }, index: true
      t.belongs_to :user, foreign_key: { on_delete: :cascade }, index: true
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :memberships, [:team_id, :user_id], unique: true
  end
end
