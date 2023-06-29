require 'httparty'

class ArtworksController < ApplicationController
  def index
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

    artwork_sections = []
    object_types.each do |object_type|
      artwork_sections.push(generate_artwork_section(object_type))
    end

    @artwork_sections = artwork_sections
  end

  private

  def generate_artwork_section(object_type)
    url_section = object_type.downcase
    url_section.sub!(" ", "_")
    # Not working
    # url_section[" "]= "_"
    artwork_section = ArtworkSection.new(
      name: object_type,
      url: url_section
    )

    return artwork_section
  end

  # To move in pages_controller.rb
  def fetch_object_type(object_type)
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?q_object_type='#{object_type}'")
    artworks_data = JSON.parse(response.body)
    artworks_records = artworks_data["records"]

    i = 1
    artworks_section_temp_array = []
    artworks_records.each do |artwork_record|
      iiif_image_base_url = artwork_record['_images']['_iiif_image_base_url']
      if iiif_image_base_url != nil
        image_url = "#{iiif_image_base_url}full/full/0/default.jpg"
        title = artwork_record['_primaryTitle']
        date = artwork_record['_primaryDate']

        artwork = Artwork.new(
          index: i,
          title: title.empty? ? object_type : title,
          date: date.empty? ? "No date" : date,
          image_url: image_url,
        )
        i += 1

        artworks_section_temp_array.push(artwork)
      end
    end
    
    # Not needed, to remove
    artwork_section = ArtworkSection.new(
      name: object_type,
      artworks: artworks_section_temp_array,
    )

    return artwork_section
  end
end
