require 'sinatra'
require "application"

map '/' do
  run Application
end
