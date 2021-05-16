class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :place_id
      t.integer :host_id
      t.string :host_name
      t.text :participants_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :party_size
      t.integer :participants_count
      t.string :city
      t.text :notes, limit: 500
      t.integer :status
      t.integer :minimum_rating

      t.timestamps
    end
    add_index :events, :place_id
  end
end
