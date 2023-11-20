module ApplicationHelper
  def avatar(model, opt={class: nil})
    content_tag :div, class: "avatar-container #{opt[:class]}" do
      concat(embedded_svg "avatar.svg", class: "animate-pulse absolute w-full h-full text-slate-200 dark:text-slate-700")
      if model.avatar.attached?
        concat(image_tag model.avatar.variant(resize_to_limit: [240, 240]), class: "avatar")
      else
        concat(image_tag 'default_profile_picture.png', class: "avatar")
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
      if model.updated_at >= 24.hours.ago # If the model was saved in the last 24 hours, use the XX:XX timestamp.
        "Last saved at #{model.updated_at.strftime('%-I:%M%P')}"
      else # Else use the day as the timestamp.
        "Last saved #{model.updated_at.strftime("%b %d, %Y")}"
      end
    else
      "Not saved"
    end
  end
end
