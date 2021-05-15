class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :from_id
      t.text :notes, limit: 500
      t.integer :stars
      # t.boolean :is_skip

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :from_id
  end
end
