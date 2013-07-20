#!/usr/bin/env ruby

require 'uri'
require 'grabberutils'
require 'grabber/openstat'

class Alexa
	include GrabberUtils

	BIG_SITE_HOST = 'rutracker.org'

	def initialize(url)
		@uri = URI.parse(url)
		@host = @uri.host
	end

	def run
		big_site_perc = get_global_percents(BIG_SITE_HOST)
		big_site_val = Openstat.new.run_id(Openstat::BIG_SITE_ID)
		p big_site_val
		r = get_global_percents(@host)
		return r
	end

	def get_global_percents(host)
		r = {}
		doc = download("http://www.alexa.com/siteinfo/#{host}#trafficstats")
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
		doc.gsub(/<td class="avg ">([0-9.]+)%<\/td>/) { |x| r << $1 }
		return r
	end
end
