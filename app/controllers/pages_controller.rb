class PagesController < ApplicationController
  def show
    section_url = params[:page_name]
    artwork_section = generate_artwork_section(section_url)
    @artwork_section = artwork_section
    object_type = artwork_section.name

    artworks = fetch_object_type(object_type)

    @artworks = artworks
  end

  private

  def generate_artwork_section(url_section)
    object_type = section_url.capitalize
    object_type.sub!(" ", "_")
    artwork_section = ArtworkSection.new(
      name: object_type,
      url: url_section
    )

    return artwork_section
  end

  def fetch_object_type(object_type)
    response = HTTParty.get("https://api.vam.ac.uk/v2/objects/search?q_object_type='#{object_type}'")
    artworks_data = JSON.parse(response.body)
    artworks_records = artworks_data["records"]

    i = 1
    artworks_array = []
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

    return artworks_array
  end
end
