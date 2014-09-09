module ApplicationHelper
  def admin?
    user_signed_in? && current_user.role == User.roles[:admin]
  end

  def boolean_image(bool)
    if bool
      "<span class='glyphicon glyphicon-ok'></span>".html_safe
    else
      "<span class='glyphicon glyphicon-remove'></span>".html_safe
    end
  end

  def role_text(user)
    role = User.roles.find { |k, v| v == user.role } || ['Unknown']
    role.first.capitalize
  end

  def access_level_text(team)
    access_level = Team.access_levels.find { |k, v| v == team.access_level } || ['Unknown']
    access_level.first.capitalize
  end

  def license_text(service)
    license = Service.licenses.find { |k, v| v == service.license } || ['Unknown']
    license.first.capitalize
  end
end
