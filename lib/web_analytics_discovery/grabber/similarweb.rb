require 'web_analytics_discovery/grabberutils'

require 'json'
require 'uri'

module WebAnalyticsDiscovery
class SimilarWeb
	include GrabberUtils

	def run(url)
		run_id(find_id(url))
	end

	def find_id(url)
		extract_domain(url).gsub(/^www\./, '')
	end

        def extract_domain(url)
		u = URI::parse(url)
		if u.host
			u.host
		else
			url
		end
        end

	def run_id(id)
		return nil unless id
		r = {:id => id}
		doc = download("http://www.similarweb.com/website/data/#{id}?_=1415995668323")

		raise "SimilarWeb JavaScript data parse error" unless doc =~ /Sw\.preloadedData = (.*?);\s*Sw\.preloadedData.overview.WeeklyTrafficNumbers = (.*?);\s*Sw\.preloadedData.overview.TotalLastMonthVisits = (.*?);\s*Sw\.period = (.*?);\s*Sw\.siteDomain = "(.*?)";\s*Sw\.siteCategory = "(.*?)";\s*Sw\.siteCountry = "(.*?)";/

		data = $1
		monthly = $2
		# last_month_visits = $3
		period = $4
		site_domain = $5
		site_category = $6
		site_country = $7

		data.gsub!(/\{overview:/, '{"overview":')

		data = JSON.load(data)
		monthly = JSON.load(monthly)
		overview = data['overview']

		# This field is called "WeeklyTrafficNumbers" in
		# JavaScript, so probably it was either used to
		# deliver weekly results in the past, or will be used
		# to deliver weekly results in the future. Let's check
		# that it indeed has only per-month data before
		# calculations.
		monthly.each_key { |k|
			raise "Non-monthly data encountered in monthly visits field - #{k}" unless k =~ /^\d\d\d\d-\d\d-01$/
		}

		eng = overview['Engagments']
		raise "Multiple values in global engagements property" if eng.size != 1
		eng = eng.first
		r[:visit_time] = eng['Time'].first
		visit_pv = eng['PPV'].first
		r[:bounce] = eng['Bounce'].first

		r[:visits_day] = avg_values(overview['TrafficNumbers']).to_i
		r[:visits_mon] = avg_values(monthly).to_i

		r[:pv_day] = (r[:visits_day] * visit_pv).to_i
		r[:pv_mon] = (r[:visits_mon] * visit_pv).to_i

		return r
	end

	def avg_values(h)
		sum = 0
		h.each_value { |v|
			sum += v
		}
		sum / h.size
	end
end
end
