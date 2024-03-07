class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.string :priority_level
      t.string :status
      t.references :category, foreign_key: true
      t.timestamps
    end
  end
end