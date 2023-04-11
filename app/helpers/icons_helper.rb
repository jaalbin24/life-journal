module IconsHelper
  def x_icon(args={})
    render inline: Rails.root.join("app", "assets", "images", "x_icon.svg").read, locals: {color: args[:color], size: args[:size]}
  end

  def chevron_icon(args={})
    render inline: Rails.root.join("app", "assets", "images", "chevron_icon.svg").read, locals: {color: args[:color], size: args[:size]}
  end

  def trashcan_icon(args={color: :white, size: 24})
    render inline: Rails.root.join("app", "assets", "images", "trash_icon.svg.erb").read, locals: {color: tailwind_color_to_hex(args[:color]), size: args[:size]}
  end

  def edit_icon(args={color: :white, size: 24})
    render inline: Rails.root.join("app", "assets", "images", "edit_icon.svg").read, locals: {color: args[:color], size: args[:size]}
  end

  def plus_icon(args={color: :white, size: 24})
    render inline: Rails.root.join("app", "assets", "images", "plus_icon.svg").read, locals: {color: args[:color], size: args[:size]}
  end

  private

  def tailwind_color_to_hex(color)
    colors = {
      "gray-100" => "#F5F5F5",
      "gray-200" => "#E5E7EB",
      "gray-300" => "#D1D5DB",
      "gray-400" => "#9CA3AF",
      "gray-500" => "#6B7280",
      "gray-600" => "#4B5563",
      "gray-700" => "#374151",
      "gray-800" => "#1F2937",
      "gray-900" => "#111827",
      "red-100" => "#FEE2E2",
      "red-200" => "#FECACA",
      "red-300" => "#FCA5A5",
      "red-400" => "#F87171",
      "red-500" => "#EF4444",
      "red-600" => "#DC2626",
      "red-700" => "#B91C1C",
      "red-800" => "#991B1B",
      "red-900" => "#7F1D1D",
      "orange-100" => "#FDE8D0",
      "orange-200" => "#FBD38D",
      "orange-300" => "#FFB350",
      "orange-400" => "#FB923C",
      "orange-500" => "#F97316",
      "orange-600" => "#EA580C",
      "orange-700" => "#C2410C",
      "orange-800" => "#9A3412",
      "orange-900" => "#7C2D12",
      "yellow-100" => "#FEF3C7",
      "yellow-200" => "#FDE68A",
      "yellow-300" => "#FCD34D",
      "yellow-400" => "#FBBF24",
      "yellow-500" => "#F59E0B",
      "yellow-600" => "#D97706",
      "yellow-700" => "#B45309",
      "yellow-800" => "#92400E",
      "yellow-900" => "#78350F",
      "green-100" => "#D1FAE5",
      "green-200" => "#A7F3D0",
      "green-300" => "#6EE7B7",
      "green-400" => "#34D399",
      "green-500" => "#10B981",
      "green-600" => "#059669",
      "green-700" => "#047857",
      "green-800" => "#065F46",
      "green-900" => "#064E3B",
      "teal-100" => "#CCFBF1",
      "teal-200" => "#99F6E4",
      "teal-300" => "#5EEAD4",
      "teal-400" => "#2DD4BF",
      "teal-500" => "#14B8A6",
      "teal-600" => "#0D9488",
      "teal-700" => "#0F766E",
      "teal-800" => "#115E59",
      "teal-900" => "#134E4A",
      "blue-100" => "#DBEAFE",
      "blue-200" => "#BFDBFE",
      "blue-300" => "#93C5FD",
      "blue-400" => "#60A5FA",
      "blue-500" => "#3B82F6",
      "blue-600" => "#2563EB",
      "blue-700" => "#1D4ED8",
      "blue-800" => "#1E40AF",
      "blue-900" => "#1E3A8A",
      "indigo-100" => "#E0E7FF",
      "indigo-200" => "#C7D2FE",
      "indigo-300" => "#A5B4FC",
      "indigo-400" => "#818CF8",
      "indigo-500" => "#6366F1",
      "indigo-600" => "#4F46E5",
      "indigo-700" => "#4338CA",
      "indigo-800" => "#3730A3",
      "indigo-900" => "#312E81",
      "purple-100" => "#EDE9FE",
      "purple-200" => "#DDD6FE",
      "purple-300" => "#C4B5FD",
      "purple-400" => "#A78BFA",
      "purple-500" => "#8B5CF6",
      "purple-600" => "#7C3AED",
      "purple-700" => "#6D28D9",
      "purple-800" => "#5B21B6",
      "purple-900" => "#4C1D95",
      "pink-100" => "#FECDD3",
      "pink-200" => "#FDA4AF",
      "pink-300" => "#FB7185",
      "pink-400" => "#F43F5E",
      "pink-500" => "#E11D48",
      "pink-600" => "#BE123C",
      "pink-700" => "#9F1239",
      "pink-800" => "#881337",
      "pink-900" => "#6B0F3A",
      "white" => "#ffffff",
      "black" => "#000000"
    }
    colors[color.to_s]
  end
end