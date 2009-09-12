
require 'ircformat/state'

module IrcFormat
  class Parser
    def initialize(code_parsers)
      @code_parsers = []
      code_parsers.each do |code_parser|
        @code_parsers << [ code_parser.code_regex, code_parser ]
      end
    end

    def parse_formatted_string(string)
      segments = []
      text_accum = ''
      state = State.new
      while string && string.length > 0
        code_string, code_parser = parse_code(string)
        if code_string
          # We just parsed a code, so we need to put the old state and accumulated text onto the segments now.
          if text_accum.length > 0
            segments << [ state.clone, text_accum ]
            text_accum = ''
          end
          code_parser.accumulate(state, code_string)
          string = string.slice(code_string.length, string.length)
        else
          # No code, keep going until there is one.  XXX: This could be more efficient.
          text_accum += string.slice(0, 1)
          string = string.slice(1, string.length)
        end
      end

      # Deal with any remaining text at the end.
      if text_accum and text_accum.length > 0
        segments << [ state, text_accum ]
      end

      segments
    end

    # Loops through each code parser until one says it found a hit.
    def parse_code(string)
      @code_parsers.each do |code_regex, code_parser|
        if match = code_regex.match(string)
          return match[0], code_parser
        end
      end
      nil
    end

  end
end
