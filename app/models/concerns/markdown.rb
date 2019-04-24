module MarkdownRenderer
  def self.render(markdown_text)
    html_doc = CommonMarker.render_doc(
      markdown_text || '',
      :SMART,
      [
        :table,
        :tagfilter,
        :autolink,
        :strikethrough
      ]
    ).to_html(
      [
        :GITHUB_PRE_LANG,
        :HARDBREAKS,
      ],
      [:tagfilter]
    ).strip

    if html_doc.empty?
      ''
    else
      "<div class=\"markdown\">\n#{html_doc}\n</div>"
    end
  end
end
