class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :micropost_id
      t.integer :comment_id
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
    # インデックス付与して検索効率アップ
    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
    add_index :notifications, :micropost_id
    add_index :notifications, :comment_id
  end
end
