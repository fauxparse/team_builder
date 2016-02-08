class CreateEventRecurrenceRules < ActiveRecord::Migration[5.0]
  def change
    create_table :event_recurrence_rules do |t|
      t.belongs_to :event, required: true, index: true,
        foreign_key: { on_delete: :cascade }
      t.integer :repeat_type, required: true, default: 0
      t.integer :interval, required: true, default: 1
      t.integer :count, required: false
      t.datetime :stops_at, required: false
      t.integer :weekdays, array: true, required: true, default: []
      t.integer :monthly_weeks, array: true, required: true, default: []
      t.timestamps
    end
  end
end
