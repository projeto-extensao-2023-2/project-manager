class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :district
      t.string :complement
      t.string :postal_code
      t.string :city
      t.string :state
      t.references :supervisor, foreign_key: true
      t.references :coordinator, foreign_key: true
      t.references :researcher, foreign_key: true

      t.timestamps
    end
  end
end
