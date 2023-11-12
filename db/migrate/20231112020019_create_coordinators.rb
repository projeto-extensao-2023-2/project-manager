class CreateCoordinators < ActiveRecord::Migration[7.1]
  def change
    create_table :coordinators do |t|
      t.string :name
      t.string :phone_number
      t.string :academic_field
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
