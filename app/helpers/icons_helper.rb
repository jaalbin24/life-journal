module IconsHelper
    def x_icon(args={})
        render inline: Rails.root.join("app", "assets", "images", "x_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end

    def chevron_icon(args={})
        render inline: Rails.root.join("app", "assets", "images", "chevron_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end

    def trashcan_icon(args={color: :white, size: 24})
        render inline: Rails.root.join("app", "assets", "images", "trash_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end

    def edit_icon(args={color: :white, size: 24})
        render inline: Rails.root.join("app", "assets", "images", "edit_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end

    def plus_icon(args={color: :white, size: 24})
        render inline: Rails.root.join("app", "assets", "images", "plus_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end
end