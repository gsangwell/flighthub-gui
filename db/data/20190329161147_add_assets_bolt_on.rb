class AddAssetsBoltOn < ActiveRecord::Migration[5.2]
  def up
    BoltOn.create!(name: 'Assets')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
