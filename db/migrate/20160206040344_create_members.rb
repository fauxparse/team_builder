class CreateMembers < ActiveRecord::Migration[5.0]
  def up
    create_table :members do |t|
      t.belongs_to :team, foreign_key: { on_delete: :cascade }, index: true
      t.belongs_to :user, foreign_key: { on_delete: :cascade }, index: true,
        required: false
      t.string :display_name, required: false
      t.boolean :admin, default: false
      t.timestamps
    end

    add_index :members, [:team_id, :user_id]

    drop_table :memberships
  end

  def down
    drop_table :members

    create_table :memberships do |t|
      t.belongs_to :team, foreign_key: { on_delete: :cascade }, index: true
      t.belongs_to :user, foreign_key: { on_delete: :cascade }, index: true
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :memberships, [:team_id, :user_id], unique: true
  end
end
