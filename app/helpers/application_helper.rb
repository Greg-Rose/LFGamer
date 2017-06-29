module ApplicationHelper
  def add_console_color_to_button(console)
    css_classes = ""
    if current_page?(games_path(console: console.id))
      if console.name.include?("PlayStation")
        css_classes = " btn-playstation disabled"
      end
      if console.name.include?("Xbox")
        css_classes = " btn-xbox disabled"
      end
    end
    css_classes
  end
end
