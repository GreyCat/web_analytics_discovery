#!/usr/bin/env ruby

require 'uri'
require 'web_analytics_discovery/grabberutils'
require 'web_analytics_discovery/grabber/openstat'

class Alexa
	include GrabberUtils

	BIG_SITE_HOST = 'rutracker.org'

	def initialize
		@big_perc = get_global_percents(BIG_SITE_HOST)
		@big_val = Openstat.new.run_id(Openstat::BIG_SITE_ID)
	end

	def run(url)
		uri = URI.parse(url)
		host = uri.host
		return calc_values(get_global_percents(host))
	end

	def get_global_percents(host)
		r = {}
		doc = download("http://www.alexa.com/siteinfo/#{host}#trafficstats")
		if doc =~ /<img src="http:\/\/traffic\.alexa\.com\/graph\?.*&u=([^"]+)">/
			r[:id] = $1
		end
		if doc =~ /<table class="visitors_percent">(.*?)<\/table>/m
			r[:visitors_week_percent], r[:visitors_mon_percent], r[:visitors_mon3_percent] = grab_percentages($1)
		end
		if doc =~ /<table class="pageviews_percent">(.*?)<\/table>/m
			r[:pv_week_percent], r[:pv_mon_percent], r[:pv_mon3_percent] = grab_percentages($1)
		end
		return r
	end

	def grab_percentages(doc)
		r = []
		doc.gsub(/<td class="avg ">([0-9.]+)%<\/td>/) { |x| r << $1.to_f }
		return r
	end

	def calc_values(r)
		# Don't calculate anything if we have no info from Alexa
		return r unless r[:visitors_mon_percent]

		r[:visitors_mon] = (@big_val[:visitors_mon] / @big_perc[:visitors_mon_percent] * r[:visitors_mon_percent]).to_i
		r[:pv_mon] = (@big_val[:pv_mon] / @big_perc[:pv_mon_percent] * r[:pv_mon_percent]).to_i

		# Approximate average daily PV from monthly PV
		r[:pv_day] = (r[:pv_mon] / AVG_DAYS_IN_MONTH).to_i

		return r
	end
end
