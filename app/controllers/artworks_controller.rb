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
    artwork_section = ArtworkSection.new(
      name: object_type,
      url: url_section
    )

    return artwork_section
  end
end

# <!-- NON FUNZIONA: -->
# <!-- <%= link_to "Open", pages_path(artwork_section.url)> -->
