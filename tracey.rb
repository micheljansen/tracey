#!/usr/bin/ruby
require "bundler"
require "kramdown"
require "erb"
require "sinatra"
require "sinatra/reloader"

set :bind, '0.0.0.0'

get "/" do

  sections = []

  dirs = Dir[File.join('public','content', '**/**')].select do |path|
    File.directory?(path)
  end
  dirs.each do |dir|
    section = {}
    section[:path] = dir
    section[:annotations] = "no annotations"

    imgs = Dir.glob(File.join(dir,"*.{jpg,jpeg,svg}"), File::FNM_CASEFOLD)
    puts imgs
    section[:imgs] = imgs.map{|img| img.gsub(/public/,"")}

    begin
      doc = Kramdown::Document.new(File.read(File.join(dir, "annotations.txt")))
      section[:annotations] = doc.to_html
    rescue => e
      puts "#{dir}: no annotations"
    end
    sections << section
  end

  p = 1
  sections.each { |s| s[:pageno] = p; p += 1 }

  erb :index, :locals  => {:sections => sections}
end
