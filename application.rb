require "./genreg"
require "sinatra"
require "sinatra/prawn"

set :prawn, { :margin => [0.25,0.25,0.25,0.25] }
set :root, File.dirname(__FILE__)
set :logging, true

get '/' do
  content_type 'application/pdf'
  headers['Cache-Control'] = "public, max-age=6000000000000000000"
  prawn :index
  
end

