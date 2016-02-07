class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.belongs_to :team, foreign_key: { on_delete: :cascade }, index: true
      t.string :name
      t.string :slug
      t.text :description
      t.datetime :starts_at
      t.datetime :stops_at
      t.string :time_zone_name
      t.integer :duration

      t.timestamps
    end

    add_index :events, [:team_id, :slug], unique: true
  end
end
