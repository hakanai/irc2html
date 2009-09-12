
require 'ircformat/parser'

module IrcFormat
  class HtmlConvertor
    COLORS = %w{ fff 000 008 080 f00 800 808 f80 ff0 0f0 088 0ff 00f f0f 888 ccc }.map{|e| e.freeze}.freeze

    def to_css(format_state)
      fgcolor, bgcolor = format_state.fgcolor, format_state.bgcolor
      if format_state.inverse
        fgcolor = format_state.bgcolor || 0
        bgcolor = format_state.fgcolor || 1
      end
      styles = []
      styles << "color: ##{COLORS[fgcolor]};" if fgcolor
      styles << "background-color: ##{COLORS[bgcolor]};" if bgcolor
      styles << "font-weight: bold;" if format_state.bold
      styles << "text-decoration: underline;" if format_state.underline
      return styles.empty? ? nil : styles.join(' ')
    end

    def escape_html(string)
      string.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('\'', '&apos;').gsub('"', '&quot;')
    end

    def irc_to_html(string)
      result = ''
      string.each_line do |line|
        IrcFormat::Parser.new.parse_formatted_string(line).each do |fragment|
          text = self.escape_html(fragment[1])
          css = self.to_css(fragment[0])
          if css
            result += "<span style=\"#{css}\">#{text}</span>"
          else
            result += text
          end
        end
      end
      result
    end
  end
end
