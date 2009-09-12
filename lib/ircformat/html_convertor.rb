
require 'ircformat/parser'
require 'ircformat/mirc_code_parser'
require 'ircformat/irssi_code_parser'

module IrcFormat
  class HtmlConvertor
    COLOR_MAPPINGS = {
      :nk => '#000000'.freeze, # dark black (black)
      :nr => '#B21717'.freeze, # dark red
      :ng => '#17B217'.freeze, # dark green 
      :ny => '#B26717'.freeze, # dark yellow (orange)
      :nb => '#1717B2'.freeze, # dark blue
      :nm => '#B217B2'.freeze, # dark magenta
      :nc => '#17B2B2'.freeze, # dark cyan
      :nw => '#B2B2B2'.freeze, # dark white (light grey)
      :ik => '#686868'.freeze, # light black (dark grey)
      :ir => '#FF5454'.freeze, # light red
      :ig => '#54FF54'.freeze, # light green
      :iy => '#FFFF54'.freeze, # light yellow
      :ib => '#5454FF'.freeze, # light blue
      :im => '#FF54FF'.freeze, # light magenta
      :ic => '#54FFFF'.freeze, # light cyan
      :iw => '#FFFFFF'.freeze, # light white (white)
    }.freeze

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

    def to_css(format_state)
      fgcolor, bgcolor = format_state.fgcolor, format_state.bgcolor
      if format_state.inverse
        fgcolor, bgcolor = (bgcolor || @defaultbg), (fgcolor || @defaultfg)
      end
      styles = []
      styles << "color: #{COLOR_MAPPINGS[fgcolor]};" if fgcolor
      styles << "background-color: #{COLOR_MAPPINGS[bgcolor]};" if bgcolor
      styles << "font-weight: bold;" if format_state.bold
      styles << "text-decoration: underline;" if format_state.underline
      styles << "font-family: monospaced;" if format_state.monospace
      return styles.empty? ? nil : styles.join(' ')
    end

    def escape_html(string)
      string.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('\'', '&apos;').gsub('"', '&quot;')
    end

    def irc_to_html(string)
      result = ''
      string.each_line do |line|
        IrcFormat::Parser.new(@code_parsers).parse_formatted_string(line).each do |fragment|
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
