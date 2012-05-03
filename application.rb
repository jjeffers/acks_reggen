require "./genreg"
require "sinatra"
require "sinatra/prawn"

set :prawn, { :margin => [0.25,0.25,0.25,0.25] }
set :root, File.dirname(__FILE__)
set :logging, true

get '/' do
  content_type 'application/pdf'

  prawn :index
  
end

