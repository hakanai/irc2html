
require 'test/unit'

require 'ircformat/html_convertor'

class TestIrssiFormatting < Test::Unit::TestCase
  def test_plain_string
    inout('Input string', 'Input string')
  end

  def test_blink
    inout("plain \004ablink\004a plain", 'plain <span class="f">blink</span> plain')
  end

  def test_underline
    inout("plain \004bunderline\004b plain", 'plain <span class="u">underline</span> plain')
  end

  def test_bold
    inout("plain \004cbold\004c plain", 'plain <span class="b">bold</span> plain')
  end

  def test_inverse
    inout("plain \004dinverse\004d plain", 'plain <span class="v">inverse</span> plain')
  end

  def test_indent
    # TODO: Implement indenting.
  end

  def test_indent_func
    inout("plain \004findent_func", 'plain indent_func')
  end

  def test_reset
    inout("plain \004cbold\004g plain", 'plain <span class="b">bold</span> plain')
  end

  def test_clrtoeol
    inout("plain \004hclrtoeol", 'plain clrtoeol')
  end

  def test_monospace
    inout("plain \004imonospace\004g plain", 'plain <span class="m">monospace</span> plain')
  end

  def test_color
    inout("\00400small bombs", '<span class="fnk bnk">small bombs</span>')
  end

  def inout(input, expected_output)
    assert_equal expected_output, IrcFormat::HtmlConvertor.new(:nk, :iw, :irssi).irc_to_html(input)
  end
end

