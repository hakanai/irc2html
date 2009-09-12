
module IrcFormat

  # Holds the formatting settings which would be used if the next character encountered were not a format string.
  class State
    attr_accessor :bold, :inverse, :underline, :monospace, :blink, :indent
    attr_accessor :fgcolor, :bgcolor

    # Resets state back to unformatted.
    def reset
      @bold = @inverse = @underline = @monospace = @blink = @indent = false
      @fgcolor = @bgcolor = nil
    end

    # Convenience method for toggling boolean attributes.
    def toggle(method)
      self.send("#{method}=".to_sym, !self.send(method))
    end
  end
end
