class CreateCustomImages < ActiveRecord::Migration
  def change
    create_table :custom_images do |t|
      t.string :uploaded_file
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
