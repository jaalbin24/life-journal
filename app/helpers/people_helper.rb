module PeopleHelper
    def person_avatar(person, options={class: nil, size: 24, link: false})
        "<div class='person-avatar-container' style='width: #{options[:size]}px; padding-bottom: #{options[:size]}px;'>#{
            if person.avatar.attached?
                image_tag person.avatar, class: options[:class], size: options[:size]
            else
                image_tag 'default_profile_picture.png', class: options[:class], size: options[:size]
            end
        }</div>".html_safe
    end
end
