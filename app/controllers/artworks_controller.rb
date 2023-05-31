require 'httparty'

class ArtworksController < ApplicationController
  def index
    # Empty the Artwork table
    Artwork.destroy_all

    object_types = [
      "Construction toy", 
      "Toy car",
      "Soft toy",
      "Educational toy",
      "Pull-along toy",
      "Puzzle",
      "Doll",
      "Mechanical toy"
    ]

    object_types.each do |object_type|
      fetch_object_type(object_type)
    end

    @artworks = Artwork.all
  end

  private

  def fetch_object_type(object_type)
    # API request:
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?q_object_type='#{object_type}'")
    # Parsing the JSON result:
    artworks_data = JSON.parse(response.body)
    artworks_info = artworks_data["info"]
    puts "*** artworks_info: #{artworks_info} *** \n\n"
    artworks_records = artworks_data["records"]
    record_count = artworks_info["record_count"]
    image_count = artworks_info["image_count"]
    puts "
      There are #{record_count} object records that have the word 'Construction toy' in the object type\n 
      But only #{image_count} images\n\n"
  
    # puts "The first object is called '#{artworks_records[0]["_primaryTitle"]}' and has the type of '#{artworks_records[0]["objectType"]}'"

    i = 1
    artworks_records.each do |artwork_record|
      image_url = artwork_record['_images']['_primary_thumbnail']

      if image_url != nil
        title = artwork_record['_primaryTitle']
        date = artwork_record['_primaryDate']

        artwork = Artwork.new(
          index: i,
          title: title.empty? ? object_type : title,
          description: date.empty? ? "No date" : date,
          image_url: image_url,
        )
        i += 1

        artwork.save
      end
    end
  end
end
