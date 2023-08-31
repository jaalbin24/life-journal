module MentionsHelper
  def mention_added_by(mention)
    if mention.added_by_user?
      "Added by you"
    else
      "Added by AI"
    end
  end
end
