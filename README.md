xpdf-ruby
=========

XPDF (pdfinfo and pdftotext command) wrapper library for Ruby

## Sample code

    require './xpdf'
    
    doc = XPDF::Reader.read('sample.pdf')
    
    puts "Title: #{doc.title}"
    puts "Author: #{doc.author}"
    puts "PDF Version: #{doc.pdf_version}"
    
    doc.pages.each do |page|
      puts page
    end
