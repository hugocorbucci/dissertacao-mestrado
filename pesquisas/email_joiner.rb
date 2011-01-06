#!/usr/bin/ruby

NAME = 1
EMAIL = 2
MAX_EMAILS_PER_PART = 200

counter = 0
merged = {}
while counter < ARGV.size
  filename = ARGV[counter]
  
  file = File.new(filename)
  file.each_with_index do |line, index|
    if index > 0
      columns = line.split(',')
      email = columns[EMAIL].gsub('"', '')
      merged[email.strip] = columns[NAME].strip if merged[columns].nil? and email.size > 0
    end
  end
  
  counter+=1
end

recipients = []
merged.each_pair do |email, name|
  recipients << "#{name} <#{email}>"
end
recipients.sort!

parts = 1 + (recipients.size / MAX_EMAILS_PER_PART)
parts.times do |part|
  first = MAX_EMAILS_PER_PART * part
  last = [recipients.size - 1, (MAX_EMAILS_PER_PART * (part+1)) - 1].min
  puts "From #{first} to #{last}:"
  puts recipients.values_at(first..last).join(',')
end