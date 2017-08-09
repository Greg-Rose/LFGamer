module ThemedConsoleHelper
  def themed_console_name(console, abbreviation = false)
    html = ""

    if console.name.include?("PlayStation")
      html += '<span class="playstation">'
    elsif console.name.include?("Xbox")
      html += '<span class="xbox">'
    end

    if abbreviation && console.abbreviation
      html += console.abbreviation
    else
      html += console.name
    end
    html += '</span>'

    html.html_safe
  end

  def themed_console_color(console)
    if console.name.include?("PlayStation")
      "playstation"
    elsif console.name.include?("Xbox")
      "xbox"
    end
  end
end
