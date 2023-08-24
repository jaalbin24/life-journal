module ApplicationHelper
  def avatar(model, opt={size: 48, class: ""})
    "<div class='avatar-container' style='width: #{opt[:size]}px; padding-bottom: #{opt[:size]}px;'>#{
      if model.avatar.attached?
        image_tag model.avatar, class: "avatar #{opt[:class]}", size: opt[:size]
      else
        image_tag 'default_profile_picture.png', class: "avatar #{opt[:class]}", size: opt[:size]
      end
    }</div>".html_safe
  end
end
