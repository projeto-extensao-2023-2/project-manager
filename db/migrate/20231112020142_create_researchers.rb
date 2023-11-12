class CreateResearchers < ActiveRecord::Migration[7.1]
  def change
    create_table :researchers do |t|
      t.string :name
      t.string :phone_number
      t.string :academic_field
      t.string :cv_link
      t.string :orcid_id
      t.string :academic_title
      t.boolean :active, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
