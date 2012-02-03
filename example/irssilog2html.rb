#!/usr/bin/ruby
#
# irssilog2html.rb - converts Irssi logs to HTML format.
#
# usage: irssilog2html.rb <file>
#

$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'erb'
require 'ircformat/html_convertor'

# title - the title for the HTML page
# log_text - IRC log text
# options - hash of options:
#   :inline_styles - if true, will use inline CSS instead of styles (less compact)
def convert(title, log_text, options = {})
  styles = File.read("#{File.dirname(__FILE__)}/../doc/example.css")
  body   = IrcFormat::HtmlConvertor.new(:code_parsers => [ :mirc, :irssi ]).irc_to_html(log_text, options)

  ERB.new(File.read("#{File.dirname(__FILE__)}/template.erb")).result(binding)
end

if $0 == __FILE__
  file = ARGV[0]
  if file
    if File.exists?(file)
      puts convert(file, File.read(file))
      exit(0)
    else
      $stderr.puts "File not found #{file}"
      exit(1)
    end
  else
    $stderr.puts "Usage: #{$0} <file>"
    exit(1)
  end
end

