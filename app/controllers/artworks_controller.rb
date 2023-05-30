require 'httparty'

class ArtworksController < ApplicationController
  def index
    # Empty the Artwork table
    Artwork.destroy_all

    # API request:
    response = HTTParty.get('https://api.vam.ac.uk/v2/objects/search?q_object_type="Construction toy"')
    artworks_data = JSON.parse(response.body)
    # puts "*** Artworks data: #{artworks_data}\n\n" 
    artworks_info = artworks_data["info"]
    # puts "*** artworks_info: #{artworks_info}\n\n"
    artworks_records = artworks_data["records"]
    puts "*** artworks_records index 2: #{artworks_records[2]} ***\n\n"
    record_count = artworks_records.length
    # record_count = artworks_info["record_count"]
    # puts "There are #{record_count} object records that have the word 'Construction toy' in the object type"
    # puts "The first object is called '#{artworks_records[0]["_primaryTitle"]}' and has the type of '#{artworks_records[0]["objectType"]}'"

    i = 1
    artworks_records.each do |artwork_record|
      title = artwork_record['_primaryTitle']
      date = artwork_record['_primaryDate']
      artwork = Artwork.new(
        index: i,
        title: title.empty? ? "No title" : title,
        description: date.empty? ? "No date" : date,
        # image_url: artwork_record['image_url']
      )
      i += 1
      artwork.save
    end

    @artworks = Artwork.all
  end
end
