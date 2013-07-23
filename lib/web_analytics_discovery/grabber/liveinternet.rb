# -*- coding: UTF-8 -*-

require 'uri'
require 'grabberutils'

class LiveInternet
	include GrabberUtils

	def run(url)
		uri = URI.parse(url)
		run_id(uri.host)
	end

	def run_id(host)
		r = {}

		doc = download("http://www.liveinternet.ru/stat/#{host}/index.csv")
		r[:pv_day], r[:visits_day], r[:visitors_day] = grab_psv(doc, 4)

		# Bail out early if no LiveInternet data available
		return r unless r[:pv_day]

		doc = download("http://www.liveinternet.ru/stat/#{host}/index.csv?period=week;total=yes")
		r[:pv_week], r[:visits_week], r[:visitors_week] = grab_psv(doc, 2)

		doc = download("http://www.liveinternet.ru/stat/#{host}/index.csv?period=month;total=yes")
		r[:pv_mon], r[:visits_mon], r[:visitors_mon] = grab_psv(doc, 2)

		return r
	end

	private
	def grab_psv(doc, col)
		r = [nil, nil, nil]
		doc.split(/\n/).each { |l|
			c = l.split(/;/)
			case c[0]
			when '"Просмотры"'
				r[0] = c[col].to_i
			when '"Сессии"'
				r[1] = c[col].to_i
			when '"Посетители"'
				r[2] = c[col].to_i
			end
		}
		return r
	end
end
