# -*- coding: UTF-8 -*-

require 'cgi'
require 'uri'
require 'json'
require 'web_analytics_discovery/grabberutils'

class Quantcast
	include GrabberUtils

	def run(url)
		uri = URI.parse(url)
		host = uri.host

		r = {}

		# Get auth cookies
		doc = download("https://www.quantcast.com/#{host}")
		if doc =~ /<td class="reach" id="reach-(.*?)">/
			r[:id] = id = $1
		else
			return nil
		end

		# Quantcast has no traffic info? We should stop here
		return r if doc =~ /content="We do not have enough information to provide a traffic estimate./

		# Use auth cookies with API call
		id_encoded = CGI::escape(id)
		doc = download(
			"https://www.quantcast.com/api/profile/traffic/?&wUnit=#{id_encoded}&country=US&period=DAY30&countType=",
			'UTF-8',
			'Referer' => "https://www.quantcast.com/#{host}",
			'X-Requested-With' => 'XMLHttpRequest',
		)

		d = JSON.load(doc).first
#		points = d['reach']['US']['PEOPLE']['WEB']
#		points.each { |pt|
#			puts Time.at(pt['timestamp']).to_s + "\t" + pt['reach'].to_s
#		}

		r[:visitors_mon] = d['summaries']['US']['PEOPLE']['WEB']['reach'].to_i

		return r
	end
end
