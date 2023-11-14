class AddStudentReferencesToAddress < ActiveRecord::Migration[7.1]
  def change
    add_reference :addresses, :student, foreign_key: true
  end
end
