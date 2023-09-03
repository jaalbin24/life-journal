module ButtonsHelper
  def edit_entry_button(entry)
    "<a class='btn-primary' href='#{edit_entry_path(@entry)}'>
      #{embedded_svg 'edit.svg', class: "w-5 h-5"}
      Edit
    </a>".html_safe
  end

  def delete_entry_button(entry)
    form_with model: entry, url: entry_path(entry), method: :delete, html: { onsubmit: "return confirm(\"Are you sure you want to delete the following entry?\\n\\n#{entry.title}\\n#{entry_last_updated(entry)}\");"} do
      "<button class='btn-error'>
        #{ embedded_svg 'trashcan.svg', class: "w-5 h-5" }
        Delete
      </button>".html_safe
    end
  end
end