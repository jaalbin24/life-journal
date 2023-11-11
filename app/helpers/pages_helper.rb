module PagesHelper
  def link_or_div(url, options, &block)
    if url.blank?
      content_tag :div, capture(&block), options
    else
      link_to url, options, &block
    end
  end

  def greeting(user)
    current_hour = Time.use_zone(user.time_zone) { Time.now.hour }
    if current_hour < 12
      "Good morning."
    else
      "Hello."
    end
  end
end


