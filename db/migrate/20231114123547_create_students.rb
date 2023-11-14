class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :social_security_number
      t.string :identity_card_number
      t.date :birth_date
      t.string :phone_number
      t.string :email
      t.string :academic_field
      t.string :course
      t.integer :semester
      t.boolean :has_subject_dependencies
      t.boolean :is_regular_student
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
