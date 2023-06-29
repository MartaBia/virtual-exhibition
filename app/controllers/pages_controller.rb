class PagesController < ApplicationController
  def show
    section_url = params[:page_name]
    # object_type = maiuscolo(spazio(section_url))
    # crea artwork section usando section_url e object_type
    #   oppure: passi solo il nome
    # crea lista di artwork usando fetch_object_type
    # cose da passare all'erb:
    #   l'artwork section
    #   la lista di artwork
  end
end
