class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.integer :ric_number
      t.integer :project_type
      t.string :institution
      t.string :course
      t.string :study_area
      t.string :research_line
      t.text :ods
      t.string :project_title
      t.text :project_summary
      t.text :key_words
      t.integer :project_status, default: 0
      t.text :anotation, default: ""
      t.date :feedback_date
      t.references :researcher, null: false, foreign_key: true
      t.references :coordinator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
