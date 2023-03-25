module IconsHelper
    def x_icon(args={})
        render inline: Rails.root.join("app", "assets", "images", "x_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end

    def chevron_icon(args={})
        render inline: Rails.root.join("app", "assets", "images", "chevron_icon.svg").read, locals: {color: args[:color], size: args[:size]}
    end
end