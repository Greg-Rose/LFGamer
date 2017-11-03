module SortingHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    arrow_css = nil
    if sort_direction == "desc"
      arrow_css = "glyphicon glyphicon-triangle-bottom"
    else
      arrow_css = "glyphicon glyphicon-triangle-top"
    end

    arrow = ""
    arrow = raw(' <span class="' + arrow_css + '" aria-hidden="true"></span>') if column == sort_column

    css_class = column == sort_column ? "current" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to params.permit(:sort, :direction).merge(sort: column, direction: direction, page: nil, console: params[:console], search: params[:search]), {class: css_class} do
      title.html_safe + arrow
    end
  end
end
