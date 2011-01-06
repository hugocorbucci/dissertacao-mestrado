#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'

CACHE_DIR=File.expand_path(File.dirname(__FILE__))+"/cache"

first_day = Date.strptime(ARGV[0], "%Y-%m-%d") if (ARGV.size > 0)
last_day = Date.strptime(ARGV[1], "%Y-%m-%d") if (ARGV.size > 1)

first_day ||= Date.today
last_day ||= Date.strptime("2001-02-01", "%Y-%m-%d") # oldest entry available

Dir.mkdir CACHE_DIR unless File.directory? CACHE_DIR

def to_filename(address)
  CACHE_DIR+"/"+address.gsub(/[^A-Za-z0-9]/, "")
end

def cached?(address)
  File.exists? to_filename(address)
end

def cache(address, value)
  cache_file = File.new(to_filename(address), "w+")
  cache_file.puts value
  cache_file.close
end

def retrieve_data(address)
  response = ""
  if(cached?(address))
    File.open(to_filename(address)) do |f|
      f.each_line {|line| response += line }
    end
  else
    open(address, 'User-Agent' => 'Ruby-Wget') do |f|
      f.each_line {|line| response += line }
    end
    cache(address, response)
  end
  response
end

current = first_day
sum = 0
releases = {}
first = {}
while(current > last_day) do
  puts "Looking for day #{current.strftime("%Y/%m/%d")}"
  day_address = current.strftime("http://freshmeat.net/%Y/%m/%d")
  
  response = retrieve_data(day_address)
  
  next_page = true
  while(next_page) do
    matches = response.scan(/\s<a href="\/projects\/([^"]+)" title="[^"]+">/)
    matches.each do |match|
      if releases[match].nil?
        releases[match] = 1
      else
        releases[match] += 1
      end
      first[match] = current
    end
    
    match = response =~ /<a href="([^\?]+\?page=\d+)" class="next_page" rel="next">/
    next_page = !match.nil?
    if (next_page)
      response = ""
      retry_read = true
      while retry_read
        begin
          response = retrieve_data("http://freshmeat.net#{$1}")
          retry_read = false
        rescue Timeout::Error
          retry_read = true
        end
      end
    end
  end
  
  release_frequency = [0, 0, 0, 0]
  releases.keys.each do |project|
    days_interval = (first_day - first[project]).to_i + 1
    release_count = releases[project]
    days_between_release = days_interval / release_count
    if(days_between_release < 30)
      release_frequency[0] += 1
    elsif(days_between_release < 180)
      release_frequency[1] += 1
    elsif(days_between_release < 365)
      release_frequency[2] += 1
    else
      release_frequency[3] += 1
    end
  end

  date_str = current.strftime("%Y-%m-%d")
  puts "Projetos com releases mensais até #{date_str} : #{release_frequency[0]}"
  puts "Projetos com releases semestrais até #{date_str} : #{release_frequency[1]}"
  puts "Projetos com releases anuais até #{date_str} : #{release_frequency[2]}"
  puts "Projetos com releases esporádicos até #{date_str} : #{release_frequency[3]}"
  
  current = current - 1
end

release_count = releases.values.inject(0){|s,v| s+v}
days = (first_day - last_day).to_f
average = release_count / days
puts "#{release_count} releases in #{days} days (from #{first_day} to #{last_day}) -- An average of #{'%.2f' % average} releases per day."
puts ""

release_frequency = [0, 0, 0, 0]
releases.keys.each do |project|
  release_count = releases[project]
  days_between_release = days / release_count
  if(days_between_release < 30)
    release_frequency[0] += 1
  elsif(days_between_release < 180)
    release_frequency[1] += 1
  elsif(days_between_release < 365)
    release_frequency[2] += 1
  else
    release_frequency[3] += 1
  end
end

puts "Total de projetos: #{release_frequency.inject(0){|a,b| a+b}}"
puts "Projetos com releases mensais : #{release_frequency[0]}"
puts "Projetos com releases semestrais : #{release_frequency[1]}"
puts "Projetos com releases anuais : #{release_frequency[2]}"
puts "Projetos com releases esporádicos : #{release_frequency[3]}"