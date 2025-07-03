class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.integer :role
      t.string :value

      t.timestamps
    end
  end
end
