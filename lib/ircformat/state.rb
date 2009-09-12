
require 'ircformat/constants'

module IrcFormat
  class State
    include Constants
    COLOR_SEQUENCE = /(\d{1,2})(?:,(\d{1,2}))?/.freeze

    attr_accessor :bold, :inverse, :underline
    attr_accessor :fgcolor, :bgcolor

    def reset
      @bold = @inverse = @underline = false
      @fgcolor = @bgcolor = nil
    end

    def accumulate(format_sequence)
      if format_sequence =~ /#{BOLD}/
        @bold = !@bold
      elsif format_sequence =~ /#{UNDERLINE}/
        @underline = !@underline
      elsif format_sequence =~ /#{INVERSE}/
        @inverse = !@inverse
      elsif format_sequence =~ /#{RESET}/
        reset
      elsif format_sequence =~ /#{COLOR}/
        (fgcolor, bgcolor) = extract_colors_from(format_sequence)
        @fgcolor = fgcolor
        @bgcolor = bgcolor
      end
    end

    def extract_colors_from(format_sequence)
      format_sequence = format_sequence.slice(1, format_sequence.length).split(/,/)
      if format_sequence.empty?
        return nil, nil;
      elsif format_sequence.length == 1
        return format_sequence[0].to_i, @bgcolor
      else
        return format_sequence[0].to_i, format_sequence[1].to_i
      end
    end
  end
end
