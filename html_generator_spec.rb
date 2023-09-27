require 'rspec'
require_relative './html_generator'

describe ::HtmlGenerator do
  it 'Returns an empty string if no block was passed' do
    expect(subject.to_html).to eq ''
  end

  shared_examples 'Returns valid html' do
    it do
      expect(result.to_html).to eq(expected_html)
    end
  end

  context 'If the block was passed' do
    it_behaves_like 'Returns valid html' do
      let(:expected_html) { "<html lang=\"ru\"><\/html>" }
      let(:result) do
        described_class.new do
          html(lang: :ru)
        end
      end
    end

    it_behaves_like 'Returns valid html' do
      let(:expected_html) { "<html><\/html>" }
      let(:result) { described_class.new { html } }
    end
  end

  context 'Indents appear for nested blocks' do
    let(:expected_html) { "<html lang=\"ru\">\n  <div class=\"some\"><\/div>\n<\/html>" }
    let(:result) do
      described_class.new do
        html(lang: :ru) do
          div(class: :some)
        end
      end
    end

    it_behaves_like 'Returns valid html'
  end

  context 'For complex nested blocks, indentation is respected' do
    let(:expected_html) { "<html>\n  <div>\n    <span id=\"1\"></span>\n    <span id=\"2\">\n      <a></a>\n    </span>\n  </div>\n  <div></div>\n</html>" }
    let(:result) do
      described_class.new do
        html do
          div do
            span(id: '1')
            span(id: '2') do
              a
            end
          end

          div
        end
      end
    end

    it_behaves_like 'Returns valid html'
  end

  context 'For self-closing tags, returns the correct html' do
    let(:expected_html) { "<input id=\"some\" value=\"100500\"\/>" }
    let(:result) do
      described_class.new do
        input(id: :some, value: 100500)
      end
    end

    it_behaves_like 'Returns valid html'
  end

  context 'For self-closing tags, returns the correct html' do
    let(:expected_html) { "<html>\n  <div></div>\n</html>" }
    let(:result) do
      described_class.new do
        html do
          div
        end
      end
    end

    it_behaves_like 'Returns valid html'
  end
end
