module ApplicationHelper
  def bootstrap_class_for flash_type
    {
      success: 'alert-success',
      notice: 'alert-info',
      alert: 'alert-warning',
      error: 'alert-danger'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def page_heading(title, button_text = nil, button_url = nil)
    content_for(:title, title)

    content_tag(:div, class: "page-header") do
      if button_text.present? && button_url.present?
        concat link_to(button_text, button_url, class: "btn btn-primary float-xs-right")
      end

      concat content_tag(:h1, title)
    end
  end
end
