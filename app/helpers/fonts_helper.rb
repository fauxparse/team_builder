module FontsHelper
  BASE_FONT_URL = "https://fonts.googleapis.com"

  def google_fonts_link_tag(*fonts)
    stylesheet_link_tag(google_fonts_url(:css, *fonts), media: "all")
  end

  def material_icons_link_tag
    stylesheet_link_tag(google_fonts_url(:icon, "Material Icons"), media: "all")
  end

  private

  def google_fonts_url(type, *fonts)
    font_names = fonts.flat_map { |font| encode_font_name(font) }.join("|")
    "#{BASE_FONT_URL}/#{type}?family=" + font_names
  end

  def encode_font_name(family, weights = nil)
    if family.respond_to?(:keys)
      family.map { |name, weights| encode_font_name(name, weights) }
    else
      # use CGI::escape to get + instead of %20
      CGI::escape(family).tap do |str|
        str << ":" + Array(weights).join(",") if weights.present?
      end
    end
  end
end
