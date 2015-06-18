class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to  :list,            index: true
      t.string      :name,            null: false
      t.integer     :position,        null: true
      t.integer     :comments_count,  null: false,  default: 0
      t.timestamps
    end
  end
end
