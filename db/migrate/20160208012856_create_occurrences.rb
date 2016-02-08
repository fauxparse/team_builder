class CreateOccurrences < ActiveRecord::Migration[5.0]
  def change
    create_table :occurrences do |t|
      t.belongs_to :event, foreign_key: true, index: true
      t.datetime :starts_at

      t.timestamps
    end

    add_index :occurrences, [:event_id, :starts_at], unique: true
  end
end
