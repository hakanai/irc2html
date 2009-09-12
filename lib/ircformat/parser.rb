
require 'ircformat/constants'
require 'ircformat/state'

module IrcFormat
  class Parser
    include Constants
    COLOR_SEQUENCE_NC = "(?:\\d{1,2}(?:,\\d{1,2})?)".freeze
    FORMAT_SEQUENCE = /#{BOLD}|#{COLOR}#{COLOR_SEQUENCE_NC}?|#{RESET}|#{INVERSE}|#{UNDERLINE}/.freeze

    def parse_formatted_string(string)
      segments = []
      formatting = State.new
      string.split(/(#{FORMAT_SEQUENCE})/).each do |part|
        if part =~ /#{FORMAT_SEQUENCE}/
          formatting.accumulate(part)
        else
          segments << [ formatting.clone, part ]
        end
      end
      segments
    end
  end
end
