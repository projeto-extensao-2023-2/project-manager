class ChangeAnotionInProjectsToAnnotation < ActiveRecord::Migration[7.1]
  def change
    rename_column :projects, :anotation, :annotation
  end
end
