module ButtonsHelper
    def edit_entry_button(entry)
        "<a class='button button-primary' href='#{edit_entry_path(@entry)}'>
            #{image_tag 'edit_icon.svg', size: 24}
        </a>".html_safe
    end

    def delete_entry_button(entry)
      form_with model: entry, url: entry_path(entry), method: :delete, html: { onsubmit: "return confirm(\"Are you sure you want to delete the following entry?\\n\\n#{entry.title}\\n#{entry.last_updated_caption}\");"} do
        "<button class='button button-danger'>
          #{trashcan_icon}
        </button>".html_safe
      end
    end
end