
module IrcFormat
  class MircCodeParser
    BOLD      = "\002".freeze
    COLOR     = "\003".freeze
    RESET     = "\017".freeze
    INVERSE   = "\026".freeze
    UNDERLINE = "\037".freeze

    CODE_REGEX = /^(#{BOLD}|#{COLOR}(?:(\d{1,2})(?:,(\d{1,2}))?)?|#{RESET}|#{INVERSE}|#{UNDERLINE})/.freeze
    CODE_PREFIX_REGEX = /^(#{BOLD}|#{COLOR}|#{RESET}|#{INVERSE}|#{UNDERLINE})/.freeze

    COLOR_MAPPINGS = [ :iw, :nk, :nb, :ng, :ir, :nr, :nm, :ny, :iy, :ig, :nc, :ic, :ib, :im, :ik, :nw ]

    # Gets the regex to match this kind of code.
    def code_regex
      CODE_REGEX
    end

    # Updates state for the code pased in.
    def accumulate(state, code_string)
      match = CODE_PREFIX_REGEX.match(code_string)
      case match[1]
      when BOLD
        state.toggle(:bold)
      when COLOR
        match = CODE_REGEX.match(code_string)
        if match[2]
          state.fgcolor = convert_color(match[2])
          if match[3]
            state.bgcolor = convert_color(match[3])
          end
        else
          state.fgcolor = nil
          state.bgcolor = nil
        end
      when RESET
        state.reset
      when INVERSE
        state.toggle(:inverse)
      when UNDERLINE
        state.toggle(:underline)
      end
    end

    # Converts a mIRC colour string which is a 1-2 character number mapping as shown in the mappings above.
    def convert_color(string)
      COLOR_MAPPINGS[string.to_i % 16]
    end
  end
end
