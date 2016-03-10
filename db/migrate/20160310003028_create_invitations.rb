class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.belongs_to :member, foreign_key: true
      t.belongs_to :sponsor
      t.string :code, required: true, limit: 40
      t.integer :status, required: true, default: 0

      t.timestamps
    end
  
    add_index :invitations, :code, unique: true
    add_foreign_key :invitations, :members, column: :sponsor_id,
      on_delete: :cascade
  end
end
