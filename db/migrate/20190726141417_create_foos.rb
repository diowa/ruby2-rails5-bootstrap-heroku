class CreateFoos < ActiveRecord::Migration[5.2]
  def change
    create_table :foos do |t|
      t.string :name

      t.timestamps
    end
  end
end
