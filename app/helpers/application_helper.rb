# frozen_string_literal: true

module ApplicationHelper
  def page_title(title)
    content_for(:title) { title.to_s }
  end

  def page_meta_description(meta_description)
    content_for(:meta_description) { meta_description.to_s }
  end

  def yield_or_default(section, default = '')
    content_for?(section) ? content_for(section) : default
  end
end
