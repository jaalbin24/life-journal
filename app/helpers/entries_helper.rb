module EntriesHelper
  def entry_last_updated(entry)
    if entry.published?
      if entry.published_at.nil?
        "Published at an unknown date"
      else
        "Published #{entry.published_at.strftime("%b %d, %Y")}"
      end
    else
      "Saved #{entry.updated_at.strftime("%b %d, %Y")}"
    end
  end
end
