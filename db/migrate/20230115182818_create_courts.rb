class CreateCourts < ActiveRecord::Migration[7.0]
  def change
    create_table :courts do |t|
      t.string :name
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
