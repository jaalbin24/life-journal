module ButtonsHelper
  def edit_button(model)
    "<a class='btn-primary' href='#{send("edit_#{model.class.to_s.downcase}_path", model)}'>
      #{embedded_svg 'edit.svg', class: "w-5 h-5"}
      Edit
    </a>".html_safe
  end

  def delete_button(model)
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :delete, html: { onsubmit: "return confirm(\"Are you sure you want to permanently delete the following #{model.class.to_s.downcase}?\\n\\n#{model.summarize}\");"}, data: { turbo: false } do
      "<button class='btn-error'>
        #{ embedded_svg 'trashcan.svg', class: "w-5 h-5" }
        Delete permanently
      </button>".html_safe
    end
  end

  def mark_as_deleted_button(model)
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :patch, html: { onsubmit: "return confirm(\"Are you sure you want to delete the following #{model.class.to_s.downcase}?\\n\\n#{model.summarize}\");"}, data: { turbo: false } do |f|
      "#{ f.hidden_field :deleted, value: true }
      <button class='btn-error'>
        #{ embedded_svg 'trashcan.svg', class: "w-5 h-5" }
        Delete
      </button>".html_safe
    end
  end

  def recover_button(model)
    form_with model: model, url: send("#{model.class.to_s.downcase}_path", model), method: :patch, data: { turbo: false } do |f|
      "#{ f.hidden_field :deleted, value: false }
      <button class='btn-primary'>
        #{ embedded_svg 'redo.svg', class: "w-5 h-5" }
        Recover
      </button>".html_safe
    end
  end
end