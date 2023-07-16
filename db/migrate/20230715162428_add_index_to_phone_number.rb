class AddIndexToPhoneNumber < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, :phone_number
    add_index :messages, :created_at
  end
end
