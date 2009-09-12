#!/usr/bin/ruby
#
# irssilog2html.rb - converts Irssi logs to HTML format.
#
# usage: irssilog2html.rb <file>
#

$LOAD_PATH << '../lib'

require 'ircformat/html_convertor'

def convert(file)
  puts <<END
<html>
  <head>
    <title>#{file}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <style type='text/css'>
      body { font-family: Monaco, 'Lucida Console', monospace; }

END

  File.open('../doc/example.css').each do |line|
    puts line
  end

  puts <<END
    </style>
  </head>
  <body class="log">
    <div>
END

  convertor = IrcFormat::HtmlConvertor.new(:code_parsers => [ :mirc, :irssi ])
  File.open(file) do |line|
    puts convertor.irc_to_html(line)
  end

  puts <<END
    </div>
  </body>
</html>
END

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

