class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :text, limit: 50
      t.string :phone_number, limit: 25
      t.integer :status, default: 0, null: false
      t.uuid :public_id, default: "gen_random_uuid()", null: false

      t.index :public_id
      t.index :status
      t.index [:status, :public_id]

      t.timestamps
    end
  end
end
