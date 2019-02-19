class AddVpnBoltOn < ActiveRecord::Migration[5.2]
  def up
    BoltOn.create!(name: 'VPN')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
