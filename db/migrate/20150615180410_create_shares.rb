class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.belongs_to  :user,   index: true
      t.belongs_to  :topic,  index: true
      t.index       [:user_id, :topic_id], unique: true
      t.timestamps
    end
  end
end
