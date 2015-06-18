class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string  :name,              null: false
      t.index   :name
      t.integer :shares_count,      null: false,  default: 0
      t.integer :invitations_count, null: false,  default: 0
      t.integer :lists_count,       null: false,  default: 0
      t.timestamps
    end
  end
end
