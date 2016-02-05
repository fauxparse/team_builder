class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.belongs_to :user, foreign_key: { on_delete: :cascade }
      t.string :provider, required: true
      t.string :uid, required: true

      t.timestamps
    end
  end
end
