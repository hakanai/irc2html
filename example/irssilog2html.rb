#!/usr/bin/ruby
#
# irssilog2html.rb - converts Irssi logs to HTML format.
#
# usage: irssilog2html.rb <file>
#

$LOAD_PATH << '../lib'

require 'erb'
require 'ircformat/html_convertor'

def convert(file)
  title  = file
  styles = File.read('../doc/example.css')
  body   = IrcFormat::HtmlConvertor.new(:code_parsers => [ :mirc, :irssi ]).irc_to_html(File.read(file))

  ERB.new(File.read(File.join(File.dirname(__FILE__), 'template.erb'))).run(binding)
end

if $0 == __FILE__
  file = ARGV[0]
  if file
    if File.exists?(file)
      convert(file)
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

