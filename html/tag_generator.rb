# frozen_string_literal: true
require_relative './definitions'

class Html::TagGenerator
  include Html::Definitions

  def html_tag(tag_name, indent_size:, inner_html: nil, **attributes)
    return self_closed_html_tag(tag_name, indent_size:, **attributes) if self_closed_tag?(tag_name)
    return empty_html_tag(tag_name, indent_size:, **attributes) if inner_html.nil? || inner_html.empty?

    filled_html_tag(tag_name, indent_size:, inner_html:, **attributes)
  end

  def html_tag?(name)
    html_tags.include?(name)
  end

  private

  def self_closed_tag?(name)
    TAGS[:self_closed].include?(name)
  end

  def html_tags
    @html_tags ||= TAGS.values.flatten
  end

  def tag_attributes(**attributes)
    return '' if attributes.empty?

    result = attributes.map do |key, value|
      "#{key}=\"#{value}\""
    end

    " #{result.join(' ')}"
  end

  def self_closed_html_tag(tag_name, indent_size:, **attributes)
    [indent(indent_size, "<#{tag_name}#{tag_attributes(**attributes)}/>")]
  end

  def empty_html_tag(tag_name, indent_size:, **attributes)
    [indent(indent_size, "<#{tag_name}#{tag_attributes(**attributes)}></#{tag_name}>")]
  end

  def filled_html_tag(tag_name, indent_size:, inner_html:, **attributes)
    [
      indent(indent_size, "<#{tag_name}#{tag_attributes(**attributes)}>"),
      *inner_html,
      indent(indent_size, "</#{tag_name}>")
    ]
  end

  def indent(indent_size, line)
    "#{' ' * indent_size}#{line}"
  end
end
