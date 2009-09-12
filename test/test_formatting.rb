
require 'test/unit'

require 'ircformat/html_convertor'

class TestFormatting < Test::Unit::TestCase
  def test_plain_string
    inout('Input string', 'Input string')
  end

  def test_color
    inout("\0031,1small bombs", '<span style="color: #000; background-color: #000;">small bombs</span>')
  end

  def test_color_reset
    inout("Some \0034red\003 text", 'Some <span style="color: #f00;">red</span> text')
  end

  def test_bold
    inout("plain \002bold\002 plain", 'plain <span style="font-weight: bold;">bold</span> plain')
  end

  def test_underline
    inout("plain \037underline\037 plain", 'plain <span style="text-decoration: underline;">underline</span> plain')
  end

  def test_reset
    inout("plain \002bold\017 plain", 'plain <span style="font-weight: bold;">bold</span> plain')
  end

  def inout(input, expected_output)
    assert_equal expected_output, IrcFormat::HtmlConvertor.new.irc_to_html(input)
  end
end

