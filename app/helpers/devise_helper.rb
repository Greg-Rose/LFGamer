module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="col-md-12">
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
