class UserLogHelper
  def self.user_presses_button(id, name, page)

  end

  def self.user_lands_on_page(id, page)

  end

  def self.user_leaves_page(id, prev_page, new_page)

  end

  def user_hits_nav_button(id, type, prev_page)
    case type
    when "dashboard"

    when "back"

    when "inviteSomeone"

    when "settings"
      
    else
      nil
    end
  end

end
