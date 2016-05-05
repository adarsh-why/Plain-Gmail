require 'sinatra'
require 'gmail'
require 'shotgun'

get '/' do
	erb :login
end

post '/' do
	@user = params[:user].strip
	@pass = params[:pass].strip

	@gmail = Gmail.connect!(@user, @pass)
	@gmail.logged_in? ? (return erb :home) : (return erb :loginfail)
end