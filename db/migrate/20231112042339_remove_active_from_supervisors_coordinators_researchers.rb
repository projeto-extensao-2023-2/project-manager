class RemoveActiveFromSupervisorsCoordinatorsResearchers < ActiveRecord::Migration[7.1]
  def change
    remove_column :supervisors, :active, :boolean
    remove_column :coordinators, :active, :boolean
    remove_column :researchers, :active, :boolean
  end
end
