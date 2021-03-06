module FormHelper
  def form_error_messages!(record)
    return '' if record.errors.empty?

    messages = record.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="col-md-12 alert-disappear">
      <div class="alert alert-danger">
        <ul>
          #{messages}
        </ul>
      </div>
    </div>
    HTML

    html.html_safe
  end
end
