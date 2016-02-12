class AssociateAllocationsWithEvents < ActiveRecord::Migration[5.0]
  def up
    change_table :allocations do |t|
      t.belongs_to :event, foreign_key: { on_delete: :cascade },
        required: true, index: true
    end

    add_index :allocations, [:event_id, :role_id]
    remove_index :allocations, [:occurrence_id, :role_id]
    remove_column :allocations, :occurrence_id
  end

  def down
    change_table :allocations do |t|
      t.belongs_to :occurrence, foreign_key: { on_delete: :cascade },
        required: true, index: true
    end

    add_index :allocations, [:occurrence_id, :role_id]
    remove_index :allocations, [:event_id, :role_id]
    remove_column :allocations, :event_id
  end
end
