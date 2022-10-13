class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :countries, temporal: true do |t|
      t.string :name

      t.timestamps
    end

    create_table :cities, temporal: true do |t|
      t.references :country

      t.string :name

      t.timestamps
    end

    create_table :schools, temporal: true do |t|
      t.references :city

      t.string :name

      t.timestamps
    end

    create_table :students, temporal: true do |t|
      t.references :school

      t.string :name

      t.timestamps
    end
  end
end
