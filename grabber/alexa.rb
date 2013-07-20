#!/usr/bin/env ruby

require 'uri'
require 'grabberutils'

class Alexa
	include GrabberUtils

	BIG_SITE_HOST = 'rutracker.org'

	def initialize(url)
		@uri = URI.parse(url)
		@host = @uri.host
	end

	def run
		big_site = get_global_percents(BIG_SITE_HOST)
		r = get_global_percents(@host)
		return r
	end

	def get_global_percents(host)
		r = {}
		doc = download("http://www.alexa.com/siteinfo/#{host}#trafficstats")
		if doc =~ /<table class="visitors_percent">(.*?)<\/table>/m
			r[:visitors_week_percent], r[:visitors_mon1_percent], r[:visitors_mon3_percent] = grab_percentages($1)
		end
		if doc =~ /<table class="pageviews_percent">(.*?)<\/table>/m
			r[:pv_week_percent], r[:pv_mon1_percent], r[:pv_mon3_percent] = grab_percentages($1)
		end
		return r
	end

	def grab_percentages(doc)
		r = []
		doc.gsub(/<td class="avg ">([0-9.]+)%<\/td>/) { |x| r << $1 }
		return r
	end
end
