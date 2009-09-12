
require 'ircformat/parser'
require 'ircformat/mirc_code_parser'
require 'ircformat/irssi_code_parser'

module IrcFormat
  class HtmlConvertor
    def initialize(defaultfg, defaultbg, code_parsers = [:mirc])
      @defaultfg = defaultfg
      @defaultbg = defaultbg
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
        IrcFormat::Parser.new(@code_parsers).parse_formatted_string(line).each do |fragment|
          text = self.escape_html(fragment[1])
          classes = self.to_css_classes(fragment[0])
          if classes
            result += "<span class=\"#{classes}\">#{text}</span>"
          else
            result += text
          end
        end
      end
      result
    end
  end
end
