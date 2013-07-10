require 'rubygems'
require 'debugger'
require 'sinatra'
require 'twitter'
require_relative 'twitter_auth'
require_relative 'compliments'

set :port, 9001
set :public_folder, File.dirname(__FILE__) + '/assets'

get '/' do
  erb :index
end

get '/donate' do
  order_id = Compliments.add_compliment_order(params[:twitter_handle], params[:compliment])

  betterplace_donation_url = "http://www.bp42.com/en/projects/1114/client_donations/new"  # go to the the betterplace.org donation form
  betterplace_donation_url << "?client_id=bettercompliments"                                     # betterplace.org will use this to figure out your callback url
  betterplace_donation_url << "&donation_presenter[donation_client_reference]=#{order_id}"       # betterplace will return this to the callback so you can figure out what the donation was for
  betterplace_donation_url << "&donation_presenter[donation_amount]=6"                           # set the default amount for the user to donate

  redirect to(betterplace_donation_url)
end


get '/postdonate' do
  if params[:status] == "DONATION_COMPLETE"
    @compliment = Compliments.get_compliment_from_order_id(params[:donation_client_reference])

    Twitter.update("#{@compliment.twitter_handle}, you are #{@compliment.compliment}")

    erb :thanks
  else
    raise "nnnnnnnnnnnnnoooooooooo, the donation was unsucessful"
  end
end

get '/how_it_works' do
  erb :how_it_works
end
