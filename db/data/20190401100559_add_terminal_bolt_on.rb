class AddTerminalBoltOn < ActiveRecord::Migration[5.2]
  def up
    BoltOn.create!(name: 'Terminal')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
