
require 'test/unit'

require 'ircformat/html_convertor'

class TestIrssiFormatting < Test::Unit::TestCase
  def test_plain_string
    inout('Input string', 'Input string')
  end

  def test_blink
    # TODO: Implement blinking.  Or decide not to...
  end

  def test_underline
    inout("plain \004bunderline\004b plain", 'plain <span style="text-decoration: underline;">underline</span> plain')
  end

  def test_bold
    inout("plain \004cbold\004c plain", 'plain <span style="font-weight: bold;">bold</span> plain')
  end

  def test_inverse
    inout("plain \004dinverse\004d plain", 'plain <span style="color: #FFFFFF; background-color: #000000;">inverse</span> plain')
  end

  def test_indent
    # TODO: Implement indenting.
  end

  def test_indent_func
    inout("plain \004findent_func", 'plain indent_func')
  end

  def test_reset
    inout("plain \004cbold\004g plain", 'plain <span style="font-weight: bold;">bold</span> plain')
  end

  def test_clrtoeol
    inout("plain \004hclrtoeol", 'plain clrtoeol')
  end

  def test_monospace
    inout("plain \004imonospace\004g plain", 'plain <span style="font-family: monospaced;">monospace</span> plain')
  end

  def test_color
    inout("\00400small bombs", '<span style="color: #000000; background-color: #000000;">small bombs</span>')
  end

  def inout(input, expected_output)
    assert_equal expected_output, IrcFormat::HtmlConvertor.new(:nk, :iw, :irssi).irc_to_html(input)
  end
end

