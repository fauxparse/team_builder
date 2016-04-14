module LoginHelper
  LOGIN_FLASH_KEYS = %w(alert notice)

  def login_flash_messages
    keys = flash.keys & LOGIN_FLASH_KEYS
    unless keys.empty?
      content_tag :div, class: "flash-messages" do
        keys.each do |key|
          concat content_tag(:p, flash[key], class: "flash #{key}-message")
        end
      end
    end
  end
end
