module AlertsHelper
  def alert_icon(style)
    case style.to_sym
    when :success
      embedded_svg 'info.svg', class: "w-8 h-8"
    when :error
      embedded_svg 'error.svg', class: "w-8 h-8"
    when :warning
      embedded_svg 'warning.svg', class: "w-8 h-8"
    else
      embedded_svg 'info.svg', class: "w-8 h-8"
    end
  end

  def alert_title(title)
    unless title.blank?
      content_tag :h5, title, class: "font-bold"
    end
  end

  def alert_body(body)
    unless body.blank?
      content_tag :p, body
    end
  end
end