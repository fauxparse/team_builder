class FixAvailabilityEnums < ActiveRecord::Migration[5.0]
  def up
    remove_column :availabilities, :enthusiasm

    execute <<~SQL
      CREATE TYPE availability_enthusiasm
        AS ENUM ('unavailable', 'possible', 'available', 'keen');
    SQL

    add_column :availabilities, :enthusiasm, :availability_enthusiasm,
      index: true, default: 'available'
  end

  def down
    remove_column :availabilities, :enthusiasm

    execute <<~SQL
      DROP TYPE availability_enthusiasm;
    SQL

    add_column :availabilities, :enthusiasm, :integer, index: true
  end
end
