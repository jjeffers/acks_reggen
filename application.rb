require "./genreg"
require "sinatra"
require "sinatra/prawn"

set :prawn, { :margin => [0.25,0.25,0.25,0.25] }
set :root, File.dirname(__FILE__)
set :logging, true

get '/' do
  
  erb :index
  
end

post '/generatemap' do
  
  @width = params[:width].to_i
  @height = params[:height].to_i
  @axis = params[:axis]
  @strength = params[:strength].to_i.abs.to_f
  @terrain = params[:terrain].to_i
  puts @terrain
  content_type 'application/pdf'
  
  prawn :generatemap
  
end

