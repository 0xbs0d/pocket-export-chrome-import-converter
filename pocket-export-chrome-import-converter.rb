#!/usr/bin/env ruby
# encoding: UTF-8

require 'fileutils'
require 'nokogiri'

# Try to read exported file from Pocket
begin
  pocket_export = File.read('ril_export2.html')
rescue Exception => e
  puts e
  exit 1
end

# Header of the Chrome bookmarks file
pocket_to_chrome_bookmarks = <<-EOS
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
EOS

tagshead = <<-EOS
<DT><H3 ADD_DATE="1610048170" LAST_MODIFIED="0">nba</H3> 
EOS
tagsss = ""

html = Nokogiri::HTML(pocket_export).css('a')
words = html.css('a').map { |el| el.attr('tags') }.uniq
words = words.sort
puts words
words.each do |word|
	# puts tag
	pocket_to_chrome_bookmarks += %Q( <DT><H3 ADD_DATE="1610048170" LAST_MODIFIED="0">#{word}</H3>\n<DL><p>\n)
	someword = word
	Nokogiri::HTML(pocket_export).css('a').each do |link|
		# puts link['tags']
		if link['tags'] == someword
			#puts someword
			pocket_to_chrome_bookmarks += %Q(  <DT><A HREF="#{link['href'].to_s}" ADD_DATE="#{link['time_added'].to_s}" ICON="">#{link.content}</A>\n)
		end
	end

	pocket_to_chrome_bookmarks += %Q( </DL><p>\n)
end

# Read every link inside the exported file and convert it to something that Chrome can handle
#Nokogiri::HTML(pocket_export).css('a').each do |link|
  # tags += %Q(#{link['tags']}\n)
  # pocket_to_chrome_bookmarks += %Q(  <DT><A HREF="#{link['href'].to_s}" ADD_DATE="#{link['time_added'].to_s}" ICON="">#{link.content}</A>\n)
#end

# Footer of the Chrome bookmarks file
pocket_to_chrome_bookmarks += "</DL><p>"

# Try to write the
begin
  # puts tags
  File.write('pocket_to_chrome_bookmarks.html', pocket_to_chrome_bookmarks)
rescue Exception => e
  puts e
  exit 1
end
