#!/usr/bin/env ruby

require 'uri'
require 'web_analytics_discovery/grabberutils'

module WebAnalyticsDiscovery
class Alexa
	include GrabberUtils

	def run(url)
		uri = URI.parse(url)
		host = uri.host
		r = {}
		doc = download("http://www.alexa.com/siteinfo/#{host}#trafficstats")

		# Try to extract certified metrics
		r[:visitors_day], r[:pv_day], r[:visitors_mon], r[:pv_mon] = grab_certified_metrics(doc)

		# Grab ID for clarity's sake
		if doc =~ /<img src="http:\/\/traffic\.alexa\.com\/graph\?.*&u=([^"]+)">/
			r[:id] = $1
		end
		return r
	end

	def grab_certified_metrics(doc)
		r = []
		doc.gsub(/<strong class="metrics-data">([0-9,]+)<\/strong>/) { r << $1 }
		r.map! { |x| x.gsub(/,/, '').to_i }
		return r
	end
end
end
