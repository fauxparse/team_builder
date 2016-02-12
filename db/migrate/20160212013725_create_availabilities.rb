class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.belongs_to :occurrence, foreign_key: true
      t.belongs_to :member, foreign_key: true
      t.integer :enthusiasm, required: true, default: 2

      t.timestamps
    end

    add_index :availabilities, [:occurrence_id, :member_id], unique: true
    add_index :availabilities, [:member_id, :occurrence_id], unique: true
  end
end
