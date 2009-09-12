
require 'test/unit'

require 'ircformat/html_convertor'

class TestMircFormatting < Test::Unit::TestCase
  def test_plain_string
    inout('Input string', 'Input string')
  end

  def test_color
    inout("\0031,1small bombs", '<span class="fnk bnk">small bombs</span>')
  end

  def test_color_reset
    inout("Some \0034red\003 text", 'Some <span class="fir">red</span> text')
  end

  def test_bold
    inout("plain \002bold\002 plain", 'plain <span class="b">bold</span> plain')
  end

  def test_underline
    inout("plain \037underline\037 plain", 'plain <span class="u">underline</span> plain')
  end

  def test_inverse
    inout("plain \026inverse\026 plain", 'plain <span class="v">inverse</span> plain')
  end

  def test_reset
    inout("plain \002bold\017 plain", 'plain <span class="b">bold</span> plain')
  end

  def inout(input, expected_output)
    assert_equal expected_output,
                 IrcFormat::HtmlConvertor.new(:code_parsers => :mirc, :break_style => :new_line).irc_to_html(input).chomp
  end
end

