class CreateArtworkSections < ActiveRecord::Migration[7.0]
  def change
    create_table :artwork_sections do |t|
      t.string :name
      t.references :artworks, foreign_key: true, array: true

      t.timestamps
    end
  end
end
