require_relative './html/tag_generator'

class HtmlGenerator
  attr_reader :result_lines

  def initialize(&block)
    @tab_size = 2.freeze
    @indent_size = 0
    @tag_generator = Html::TagGenerator.new
    @block_results = {}
    @block_results_pointer = nil
    @result = process_block(&block)
  end

  def to_html
    return '' if result.empty?

    result.flatten.join("\n")
  end

  def method_missing(tag_name, **attributes, &block)
    @indent_size += tab_size
    last_pointer = block_results_pointer

    inner_html = process_block(&block)

    @block_results_pointer = last_pointer
    @indent_size -= tab_size

    @block_results[block_results_pointer] += tag_generator.html_tag(tag_name, indent_size:, inner_html:, **attributes)
  end

  def respond_to_missing?(name, _)
    tag_generator.html_tag?(name)
  end

  private

  attr_reader :block_results_pointer, :indent_size, :result, :tag_generator, :tab_size

  def process_block(&block)
    return [] unless block_given?

    @block_results_pointer = block.to_s
    @block_results[block_results_pointer] = []
    self.instance_eval(&block)
    @block_results[block_results_pointer]
  end
end
