#!/usr/bin/env ruby
# 2012-01-11 Bryan McLellan <btm@loftninjas.org>
# Fetch the list of repositories from a Github user and 'git clone' them all
 
require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
 
if ARGV[0].nil?
	abort "Usage: ./sync.rb [github username here]"
end

url = "https://api.github.com/users/#{ARGV[0]}/repos"
dir = "."
 
Dir.chdir(dir)
 
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
request.add_field('User-Agent', 'Sync.rb Command Line Tool')

resp = http.request(request)

data = resp.body
 
result = JSON.parse(data)
 
result.each { |repo|
 puts "Fetching #{repo['full_name']}"
 system "git clone git@github.com:#{repo['full_name']}.git"
}
