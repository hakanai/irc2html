
module IrcFormat
  class IrssiCodeParser
    PREFIX    = "\004".freeze

    # Actually we only know about a-i.
    CODE_REGEX = /^#{PREFIX}([a-z]|(.)(.))/.freeze
    #CODE_PREFIX_REGEX = /^(#{BOLD}|#{COLOR}|#{RESET}|#{INVERSE}|#{UNDERLINE})/.freeze

    COLOR_MAPPINGS = [ :nk, :nb, :ng, :nc, :nr, :nm, :ny, :nw, :ik, :ib, :ig, :ic, :ir, :im, :iy, :iw ]

    # Gets the regex to match this kind of code.
    def code_regex
      CODE_REGEX
    end

    # Updates state for the code pased in.
    def accumulate(state, code_string)
      match = CODE_REGEX.match(code_string)
      case match[1]
      when 'a'
        state.toggle(:blink)
      when 'b'
        state.toggle(:underline)
      when 'c'
        state.toggle(:bold)
      when 'd'
        state.toggle(:inverse)
      when 'e'
        state.indent = true
      when 'f'
        # indent_func
      when 'g'
        state.reset
      when 'h'
        # clrtoelf
      when 'i'
        state.toggle(:monospace)
      when ['j'..'z']
        raise ArgumentError, "Unknown escape ^D#{match[1]}"
      else
        if col = convert_color(match[2])
          state.fgcolor = col
        end
        if col = convert_color(match[3])
          state.bgcolor = col
        end
      end
    end

    # Converts a single character string colour code into a standard colour.
    def convert_color(string)
      char = string[0]
      # 47 here is the slash character.
      return nil if char == 255 || char == 47
      COLOR_MAPPINGS[(char - 48) % 16]
    end
  end
end
