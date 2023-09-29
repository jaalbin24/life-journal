module PagesHelper
  def link_or_div(url, options, &block)
    if url.blank?
      content_tag :div, capture(&block), options
    else
      link_to url, options, &block
    end
  end
end


