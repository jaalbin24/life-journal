module DropdownHelper
  def edit_dropdown_item(model, options={})
    "<div class='group'>
      <a class='dropdown-link' href='#{send("edit_#{model.class.to_s.downcase}_path", model)}'>
        #{embedded_svg 'edit.svg', class: "w-5 h-5"}
        Edit
      </a>
    </div>".html_safe
  end

  def delete_dropdown_item(model, options={})
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :delete, class: 'group', html: { onsubmit: "return confirm(\"Are you sure you want to permanently delete the following #{model.class.to_s.downcase}?\\n\\n#{model.summarize}\");"}, data: { turbo: false } do
      "<button class='dropdown-link'>
        #{ embedded_svg 'trashcan.svg', class: "w-5 h-5" }
        Delete permanently
      </button>".html_safe
    end
  end

  def mark_as_deleted_dropdown_item(model, options={})
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :patch, class: 'group', html: { onsubmit: "return confirm(\"Are you sure you want to delete the following #{model.class.to_s.downcase}?\\n\\n#{model.summarize}\");"}, data: { turbo: false } do |f|
      "#{ f.hidden_field :deleted, value: true }
      <button class='dropdown-link'>
        #{ embedded_svg 'trashcan.svg', class: "w-5 h-5" }
        Delete
      </button>".html_safe
    end
  end

  def recover_dropdown_item(model, options={})
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :patch, class: 'group', data: { turbo: false } do |f|
      "#{ f.hidden_field :deleted, value: false }
      <button class='dropdown-link'>
        #{ embedded_svg 'redo.svg', class: "w-5 h-5" }
        Recover
      </button>".html_safe
    end
  end
end