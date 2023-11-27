class CreateNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :notices do |t|
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps
    end
  end
end
