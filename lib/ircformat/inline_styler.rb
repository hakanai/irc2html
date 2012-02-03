
module IrcFormat

  # See http://ethanschoonover.com/solarized
  SOLARIZED_COLOR_MAPPINGS = {
    'nk' => '#073642',
    'nr' => '#D30102',
    'ng' => '#859900',
    'ny' => '#B58900',
    'nb' => '#268BD2',
    'nm' => '#D33682',
    'nc' => '#2AA198',
    'nw' => '#EEE8D5',
    'ik' => '#002B36',
    'ir' => '#CB4B16',
    'ig' => '#586E75',
    'iy' => '#657B83',
    'ib' => '#839496',
    'im' => '#6C71C4',
    'ic' => '#93A1A1',
    'iw' => '#FDF6E3',
  }

  XTERM_COLOR_MAPPINGS = {
    'nk' => '#000000',
    'nr' => '#CD0000',
    'ng' => '#00CD00',
    'ny' => '#CDCD00',
    'nb' => '#0000EE',
    'nm' => '#CD00CD',
    'nc' => '#00CDCD',
    'nw' => '#E5E5E5',
    'ik' => '#7F7F7F',
    'ir' => '#FF0000',
    'ig' => '#00FF00',
    'iy' => '#FFFF00',
    'ib' => '#5C5CFF',
    'im' => '#FF00FF',
    'ic' => '#00FFFF',
    'iw' => '#FFFFFF',
  }

  COLOR_MAPPINGS = XTERM_COLOR_MAPPINGS

  DEFAULT_FOREGROUND = COLOR_MAPPINGS['nw']
  DEFAULT_BACKGROUND = COLOR_MAPPINGS['nk']

#elif [ "$1" = "--palette=solarized-xterm" ]; then
#   # Above mapped onto the xterm 256 color palette
#   P0=262626;  P1=AF0000;  P2=5F8700;  P3=AF8700;
#   P4=0087FF;  P5=AF005F;  P6=00AFAF;  P7=E4E4E4;
#   P8=1C1C1C;  P9=D75F00; P10=585858; P11=626262;
#  P12=808080; P13=5F5FAF; P14=8A8A8A; P15=FFFFD7;
#  shift;
#elif [ "$1" = "--palette=tango" ]; then
#   # Gnome default
#   P0=000000;  P1=CC0000;  P2=4E9A06;  P3=C4A000;
#   P4=3465A4;  P5=75507B;  P6=06989A;  P7=D3D7CF;
#   P8=555753;  P9=EF2929; P10=8AE234; P11=FCE94F;
#  P12=729FCF; P13=AD7FA8; P14=34E2E2; P15=EEEEEC;
#  shift;
#else # linux console
#   P0=000000;  P1=AA0000;  P2=00AA00;  P3=AA5500;
#   P4=0000AA;  P5=AA00AA;  P6=00AAAA;  P7=AAAAAA;
#   P8=555555;  P9=FF5555; P10=55FF55; P11=FFFF55;
#  P12=5555FF; P13=FF55FF; P14=55FFFF; P15=FFFFFF;
#  [ "$1" = "--palette=linux" ] && shift
#fi

  class InlineStyler

    # TODO: Configurable colour schemes

    # Generates a css inline style string for the overall content
    def self.body_style
      "padding:1em;color:#{DEFAULT_FOREGROUND};background-color:#{DEFAULT_BACKGROUND}"
    end

    # Converts a css class list string into an inline style string.
    def self.style(classes)
      return nil if !classes
      classes = classes.split(' ')
      inline_styles = { 'color' => DEFAULT_FOREGROUND, 'background-color' => DEFAULT_BACKGROUND }
      
      COLOR_MAPPINGS.each_pair do |suffix, color|
        if classes.delete("f#{suffix}")
          inline_styles['color'] = color
        end
        if classes.delete("b#{suffix}")
          inline_styles['background-color'] = color
        end
      end

      if classes.delete('v')
        temp = inline_styles['color']
        inline_styles['color'] = inline_styles['background-color']
        inline_styles['background-color'] = temp
      end

      if classes.delete('b')
        inline_styles['font-weight'] = 'bold'
      end

      if classes.delete('u')
        inline_styles['text-decoration'] = 'underline'
      end

      if classes.delete('m')
        inline_styles['font-family'] = 'monospace'
      end

      if classes.delete('f')
        # find a way to do blinking, if you want it
      end

      if !classes.empty?
        raise "Forgot to implement a style mapping for a class: #{classes.inspect}"
      end

      inline_styles.map{|k,v| "#{k}:#{v}"}.join(';')
    end
  end
end

