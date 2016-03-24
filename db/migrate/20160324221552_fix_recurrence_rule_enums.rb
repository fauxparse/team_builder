class FixRecurrenceRuleEnums < ActiveRecord::Migration[5.0]
  def up
    remove_column :event_recurrence_rules, :repeat_type

    execute <<~SQL
      CREATE TYPE repeat_type
        AS ENUM (
          'never', 'daily', 'weekly',
          'monthly_by_day', 'monthly_by_week',
          'yearly_by_date', 'yearly_by_day'
        );
    SQL

    add_column :event_recurrence_rules, :repeat_type, :repeat_type,
      index: true, default: 'never'
  end

  def down
    remove_column :event_recurrence_rules, :repeat_type

    execute <<~SQL
      DROP TYPE repeat_type;
    SQL

    add_column :event_recurrence_rules, :repeat_type, :integer
  end
end
