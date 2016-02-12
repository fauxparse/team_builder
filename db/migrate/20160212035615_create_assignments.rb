class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.belongs_to :occurrence, foreign_key: { on_delete: :cascade }
      t.belongs_to :allocation, foreign_key: { on_delete: :cascade }
      t.belongs_to :member, foreign_key: { on_delete: :cascade }
      t.integer :position

      t.timestamps
    end

    add_index :assignments, [:occurrence_id, :allocation_id, :member_id],
      unique: true, name: :assignments_by_ids
    add_index :assignments, [:member_id,:occurrence_id],
      unique: true, name: :assignments_by_member
  end
end
