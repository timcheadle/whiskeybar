module ApplicationHelper
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
