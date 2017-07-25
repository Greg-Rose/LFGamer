module ApplicationHelper
  def add_console_color_to_button(console)
    css_classes = ""
    if params[:console].to_i == console.id
      if console.name.include?("PlayStation")
        css_classes = " btn-playstation disabled"
      end
      if console.name.include?("Xbox")
        css_classes = " btn-xbox disabled"
      end
    end
    css_classes
  end

  # For LFGs list
  def show_console_username_if_chosen(lfg)
    if lfg.show_console_username?
      if lfg.console.name.include?("PlayStation")
        lfg.user.profile.psn_id
      elsif lfg.console.name.include?("Xbox")
        lfg.user.profile.xbox_gamertag
      end
    end
  end
end
