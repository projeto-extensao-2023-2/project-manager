class CreateSupervisors < ActiveRecord::Migration[7.1]
  def change
    create_table :supervisors do |t|
      t.string :name
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
