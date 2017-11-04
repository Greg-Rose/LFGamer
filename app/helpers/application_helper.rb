module ApplicationHelper
  def add_console_color_to_button(console)
    css_classes = ""

    if console.name.include?("PlayStation")
      css_classes = " btn-playstation"
    elsif console.name.include?("Xbox")
      css_classes = " btn-xbox"
    elsif console.name.include?("Nintendo")
      css_classes = " btn-nintendo"
    end
    css_classes += " disabled" if params[:console].to_i == console.id

    css_classes
  end

  # For LFGs list
  def show_console_username_if_chosen(lfg)
    if lfg.show_console_username?
      html = ""
      if lfg.console.name.include?("PlayStation")
        html = "- " + "<span class='#{themed_console_color(lfg.console)}'>" + lfg.user.profile.psn_id if lfg.user.profile.psn_id?
      elsif lfg.console.name.include?("Xbox")
        html = "- " + "<span class='#{themed_console_color(lfg.console)}'>" + lfg.user.profile.xbox_gamertag if lfg.user.profile.xbox_gamertag?
      end

      html.html_safe
    end
  end
end
