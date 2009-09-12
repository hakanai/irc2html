
require 'ircformat/parser'
require 'ircformat/mirc_code_parser'
require 'ircformat/irssi_code_parser'

module IrcFormat
  class HtmlConvertor

    # Constructor.  Supported options:
    #   :code_parsers    - Array of values :mirc and/or :irssi, or arbitrary objects responding to the same methods.
    #                      Default is [:mirc]
    #   :break_style     - :new_line or :br_tag.  Default is :br_tag.
    def initialize(options)
      @break_style = options[:break_style] || :br_tag
      code_parsers = options[:code_parsers] || [:mirc]
      @code_parsers = []
      code_parsers = [ code_parsers ] unless code_parsers.respond_to?(:each)
      code_parsers.each do |code_parser_or_sym|
        case code_parser_or_sym
        when :mirc
          @code_parsers << IrcFormat::MircCodeParser.new
        when :irssi
          @code_parsers << IrcFormat::IrssiCodeParser.new
        else
          @code_parsers << code_parser_or_sym
        end
      end
    end

    def to_css_classes(state)
      classes = []
      classes << "f#{state.fgcolor}" if state.fgcolor
      classes << "b#{state.bgcolor}" if state.bgcolor
      classes << "v" if state.inverse
      classes << "b" if state.bold
      classes << "u" if state.underline
      classes << "m" if state.monospace
      classes << "f" if state.blink
      return classes.empty? ? nil : classes.join(' ')
    end

    def escape_html(string)
      string.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('\'', '&apos;').gsub('"', '&quot;')
    end

    def irc_to_html(string)
      result = ''
      string.each_line do |line|
        IrcFormat::Parser.new(@code_parsers).parse_formatted_string(line.chomp).each do |fragment|
          text = self.escape_html(fragment[1])
          classes = self.to_css_classes(fragment[0])
          if classes
            text = "<span class=\"#{classes}\">#{text}</span>"
          end
          result += text
        end

        if @break_style == :br_tag
          result += "<br/>\n"
        else
          result += "\n"
        end
      end
      result
    end
  end
end
