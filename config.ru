require 'rubygems'
require 'bundler'

Bundler.require

require './tracey'
run Sinatra::Application
