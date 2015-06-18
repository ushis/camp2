class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to  :topic, index: true
      t.string      :email, null: false
      t.index       [:topic_id, :email], unique: true
      t.timestamps
    end
  end
end
