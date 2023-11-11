module ApplicationHelper
  def avatar(model, opt={size: 48, class: ""})
    content_tag :div, class: "avatar-container #{opt[:class]}" do
      if model.avatar.attached?
        image_tag model.avatar.variant(resize_to_limit: [240, 240]), class: "avatar #{opt[:class]}"
      else
        image_tag 'default_profile_picture.png', class: "avatar #{opt[:class]}"
      end
    end
  end

  def embedded_svg(filename, opt = {})
    assets = Rails.application.assets
    asset = assets.find_asset(filename)
    if asset
      file = asset.source.force_encoding("UTF-8")
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css "svg"
      svg["class"] = opt[:class] if opt[:class].present?
    else
      # doc = "<!-- SVG #{filename} not found -->"
    end
    raw doc
  end

  def last_saved_at(model)
    if model.persisted?
      "Last saved at #{model.updated_at.strftime('%-I:%M%P')}"
    else
      "Not saved"
    end
  end
end
