class CreateAllocations < ActiveRecord::Migration[5.0]
  def change
    create_table :allocations do |t|
      t.belongs_to :occurrence, foreign_key: { on_delete: :cascade },
        required: true, index: true
      t.belongs_to :role, foreign_key: { on_delete: :cascade },
        required: true, index: true
      t.integer :minimum, required: true, default: 0
      t.integer :maximum, required: false
      t.integer :position

      t.timestamps
    end

    add_index :allocations, [:occurrence_id, :role_id]
  end
end
