class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :position
      t.integer :reportto
      t.string :firstname
      t.string :lastname
      t.text :positiontitle

      t.timestamps
    end
  end
end
