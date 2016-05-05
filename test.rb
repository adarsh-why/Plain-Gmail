require 'gmail'
require 'json'

gmail = Gmail.connect!("rubygeekskool", "apple007")
arr = []
 gmail.inbox.emails(:read).each do |mail| 

	puts "From :- #{(mail.message.from[0])}"
	puts "Subject :- #{mail.message.subject}"

	mail_body = mail.message.body.to_s
	
	if mail_body.include? 'html'
		start = mail_body.index("UTF-8")
		last = mail_body.index("\n\n--")
		puts "Body :- #{mail_body[(start+5)...last].strip}"
	else
		puts "Body :- #{mail_body.strip}"
	end

	puts "Date :- #{Date.parse(mail.date)}\n\n"
	arr << {from: mail.message.from[0], subject: mail.message.subject, date: (Date.parse(mail.date)).to_s}
end 

puts gmail.inbox.count(:unread)
puts gmail.inbox.count(:read)
puts "\n\n\n"
puts arr.to_json