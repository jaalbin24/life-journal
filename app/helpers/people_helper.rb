module PeopleHelper
    def person_avatar(person, **options)
        link = options.fetch(:link, false)
        css_class = options.fetch(:class, "person-avatar")
        size = options.fetch(:size, 24)
        
        "<div class='person-avatar-container#{link ? '' : ' hover:scale-100'}' style='width: #{size}px; padding-bottom: #{size}px;'>#{
            if person.avatar.attached?
                image_tag person.avatar, class: css_class, size: size
            else
                image_tag 'default_profile_picture.png', class: css_class, size: size
            end
        }</div>".html_safe
    end
end
