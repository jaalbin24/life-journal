module RecoverableHelper

  # time_until_deletion returns a string representing the amount of time left until the supplied model is deleted.
  # Examples:
  #   time_until_deleted(user) => "30 days"
  #   time_until_deleted(entry) => "9 hours"
  def time_until_deletion(model)
    distance_of_time_in_words(DateTime.current, model.will_be_permanently_deleted_at)
  end

  def deletion_timer(model)
    if model.deleted?
      content_tag :div, class: "absolute rounded-tr-lg rounded-bl-lg bg-red-600 bg-opacity-70 right-0 top-0 z-20 flex gap-1 items-center px-2 py-1" do
        concat(embedded_svg "trashcan.svg", class: "w-6 h-6")
        concat(time_until_deletion model)
      end
    end
  end
end