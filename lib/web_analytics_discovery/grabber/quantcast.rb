# -*- coding: UTF-8 -*-

require 'cgi'
require 'uri'
require 'json'
require 'web_analytics_discovery/grabberutils'

module WebAnalyticsDiscovery
class Quantcast
	include GrabberUtils

	def run(url)
		uri = URI.parse(url)
		run_id(uri.host)
	end

	def run_id(host)
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

		return run_id_quantified(r, host) if doc =~ /<h4>Quantified<\/h4>/

		# Use auth cookies with API call
		d = traffic_api_call(host, id, 'US', 'DAY30')

#		points = d['reach']['US']['PEOPLE']['WEB']
#		points.each { |pt|
#			puts Time.at(pt['timestamp']).to_s + "\t" + pt['reach'].to_s
#		}

		r[:visitors_mon] = d['summaries']['US']['PEOPLE']['WEB']['reach'].to_i

		return r
	end

	# Parse more precise, direct statistics on a quantified site
	def run_id_quantified(r, host)
		d = traffic_api_call(host, r[:id], 'GLOBAL', 'DAY1')
		r[:visitors_day] = avg_last_metric(d, 'UNIQUES', 7)
		r[:pv_day] = avg_last_metric(d, 'PAGE_VIEWS', 7)
		r[:visits_day]= avg_last_metric(d, 'VISITS', 7)

		d = traffic_api_call(host, r[:id], 'GLOBAL', 'DAY7')
		r[:visitors_week] = avg_last_metric(d, 'UNIQUES', 1)
		r[:pv_week] = avg_last_metric(d, 'PAGE_VIEWS', 1)
		r[:visits_week]= avg_last_metric(d, 'VISITS', 1)

		d = traffic_api_call(host, r[:id], 'GLOBAL', 'DAY30')['summaries']['GLOBAL']
		r[:visitors_mon] = d['UNIQUES']['WEB']['reach'].to_i
		r[:pv_mon] = d['PAGE_VIEWS']['WEB']['reach'].to_i
		r[:visits_mon] = d['VISITS']['WEB']['reach'].to_i

		return r
	end

	def traffic_api_call(host, id, country, period)
		id_encoded = CGI::escape(id)
		doc = download(
			"https://www.quantcast.com/api/profile/traffic/?&wUnit=#{id_encoded}&country=#{country}&period=#{period}&countType=",
			'UTF-8',
			'Referer' => "https://www.quantcast.com/#{host}?country=#{country}",
			'X-Requested-With' => 'XMLHttpRequest',
		)
		return JSON.load(doc).first
	end

	def avg_last_metric(d, metric, last_n)
		sum = 0
		d['reach']['GLOBAL'][metric]['ONLINE_WEB'][-last_n..-1].each { |pt| sum += pt['reach'] }
		d['reach']['GLOBAL'][metric]['MOBILE_WEB'][-last_n..-1].each { |pt| sum += pt['reach'] }
		return (sum / last_n).to_i
	end
end
end
