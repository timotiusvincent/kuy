class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :name
      t.integer :gender
      t.string :email
      t.text :fun_fact, limit: 500

      t.timestamps
    end
    add_index :users, :access_token, unique: true
  end
end
