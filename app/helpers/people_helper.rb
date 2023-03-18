module PeopleHelper
    def person_avatar(person, options={class: nil, size: nil, link: false})
        if person.avatar.attached?
            image_tag person.avatar, class: options[:class], size: options[:size]
        else
            image_tag 'default_profile_picture.png', class: options[:class], size: options[:size]
        end
    end
end
