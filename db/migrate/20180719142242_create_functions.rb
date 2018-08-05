class CreateFunctions < ActiveRecord::Migration[5.2]
  def change
    create_table :functions do |t|
      t.string :name,     null: false
      t.string :content
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
