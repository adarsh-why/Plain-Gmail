require 'sinatra'
require 'gmail'
require 'shotgun'
require 'json'

get '/' do
	erb :login
end

post '/' do
	@user = params[:user].strip
	@pass = params[:pass].strip

	# connect to gmail with username and password from post request
	gmail = Gmail.connect!(@user, @pass)
		
	# declaring empty array to store from, subject, date, body of each email    
	@array = []

	# looping through each email
 	gmail.inbox.emails(:read).each do |mail| 
	mail_body = mail.message.body.to_s		
		if mail_body.include? 'html'
			start = mail_body.index("UTF-8")
			last = mail_body.index("\n\n--")
			body = mail_body[(start+5)...last].strip
		else
			body = mail_body.strip
		end
	
		# appending data of each email as key:value pair inside the array
		@array << {from: mail.message.from[0], 
					subject: mail.message.subject, 
					date: (Date.parse(mail.date)).to_s,
					body: body} 
	end

	# converting array of objects into JSON
	@mail_json = @array.to_json

	#writing JSON file to a file
  	File.open('mail.json', 'w') do |file|   
    file.puts @array.to_json
	end

	# create Done, Defer, Delegate and Respond labels if doesn't exist in gmail
	gmail.labels.add("Done")      unless gmail.labels.exists?("Done")
	gmail.labels.add("Defer")     unless gmail.labels.exists?("Defer")
	gmail.labels.add("Delegate")  unless gmail.labels.exists?("Delegate")
	gmail.labels.add("Responded") unless gmail.labels.exists?("Responded")

	#return the inbox after verifying labels in gmail
	return erb :inbox
end