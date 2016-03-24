class FixInvitationEnums < ActiveRecord::Migration[5.0]
  def up
    remove_column :invitations, :status

    execute <<~SQL
      CREATE TYPE invitation_status
        AS ENUM ('pending', 'accepted', 'declined');
    SQL

    add_column :invitations, :status, :invitation_status,
      index: true, default: 'pending'
  end

  def down
    remove_column :invitations, :status

    execute <<~SQL
      DROP TYPE invitation_status;
    SQL

    add_column :invitations, :status, :integer, index: true
  end
end
