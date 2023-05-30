class CreateArtworks < ActiveRecord::Migration[7.0]
  def change
    create_table :artworks do |t|
      t.integer :index
      t.string :title
      t.string :date
      t.text :description
      t.string :object_type
      t.string :image_url

      t.timestamps
    end
  end
end
