class AddConsoleBoltOn < ActiveRecord::Migration[5.2]
  def up
    BoltOn.create!(name: 'Console')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
