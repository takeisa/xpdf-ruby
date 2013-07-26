# -*- coding: utf-8 -*-
# author: Satoshi Takei <s.takei.dev@gmail.com>
require 'tempfile'
require 'fileutils'

module XPDF
  PDFINFO_CMD = "pdfinfo"
  PDFTOTEXT_CMD = "pdftotext"

  module Reader
    def self.read(file_name)
      doc = Document.new
      info = pdfinfo_command(file_name)
      pdf_info = PDFInfo.new(info)
      doc.set_pdf_info(pdf_info)
      text = pdftotext_command(file_name)
      doc.set_text(text)
      doc
    end

    def self.pdfinfo_command(file_name)
      `#{PDFINFO_CMD} '#{file_name}'`
    end

    def self.pdftotext_command(file_name)
      temp_file = Tempfile.new("pdftotext")
      `#{PDFTOTEXT_CMD} '#{file_name}' #{temp_file.path}`
      begin
        open(TEXT_TEMP_FILE, 'r') do |f|
          f.read
        end
      ensure
        FileUtils.rm(temp_file.path)
      end
    end
  end

  class PDFInfo
    def initialize(text)
      @text = text
    end

    def attr_value(attr_name)
      if @text =~ /^#{attr_name}:\s*(.*)/
        return $1
      end
      ""
    end

    def author
      attr_value "Author"
    end

    def title
      attr_value "Title"
    end

    def pdf_version
      attr_value "PDF version"
    end
  end

  class Document
    attr_reader :title, :author, :pdf_version
    attr_reader :pages

    def set_pdf_info(pdf_info)
      @author = pdf_info.author
      @title = pdf_info.title
      @pdf_version = pdf_info.pdf_version
    end

    def set_text(text)
      @pages = text.split "\x0c"
    end
  end
end
