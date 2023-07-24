module PicturesHelper
    def picture_html(picture)
        return if picture.nil?
        "<div class='entry-picture-container'>#{
            image_tag picture.file, class: 'entry-picture'
        }<h4 class='entry-picture-title'>#{picture.title}</h4>
        <span class='entry-picture-description'>#{picture.description}</span>
        </div>".html_safe
    end
end
