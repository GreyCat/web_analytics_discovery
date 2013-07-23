# -*- coding: UTF-8 -*-

require 'json'
require 'grabberutils'

class YandexMetrika
	include GrabberUtils

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /yaCounter(\d+) = new Ya\.Metrika\(\{id:(\d+)/
			$1
		else
			nil
		end
	end

	def run_id(id)
		return nil unless id
		r = {:id => id}

		json = download("http://bs.yandex.ru/informer/#{id}/json")

		# Unfortunately, it's very weird JSON, so it's easier to parse it with regexp
		# {pageviews:[42917,576537,764371,843611,826967,1009246,990612],visits:[21298,278959,309217,335495,324285,420460,430497],uniques:[20511,240509,254201,275157,270031,356657,366913],

		r[:pv_day] = do_list($1) if json =~ /pageviews:\[([0-9,]+)\]/
		r[:visits_day] = do_list($1) if json =~ /visits:\[([0-9,]+)\]/
		r[:visitors_day] = do_list($1) if json =~ /uniques:\[([0-9,]+)\]/

		# Calculate approximations
		r[:pv_week] = r[:pv_day] * 7 if r[:pv_day]
		r[:pv_mon] = (r[:pv_day] * AVG_DAYS_IN_MONTH).to_i if r[:pv_day]

		return r
	end

	def do_list(list)
		els = list.split(/,/).map { |x| x.to_i }

		# Throw out first element, it's current day, which is incomplete
		els.shift

		sum = els.inject { |a, b| a + b }
		return sum / els.size
	end
end
