require 'grabberutils'

class Openstat
	include GrabberUtils

	BIG_SITE_ID = 601119

	def run_id(id)
		r = {}
		doc = download("http://rating.openstat.ru/site/#{id}")
		r[:visitors_day] = grab(doc, 'osb-rating_site-e-table-col-m-day')
		r[:visitors_mon] = grab(doc, 'osb-rating_site-e-table-col-m-month')
		return r
	end

	def grab(doc, classname)
		if doc =~ /#{classname}">([^<]+)<\/td>/
			r = $1
			r.gsub!(/&nbsp;/, '')
			r.to_i
		else
			nil
		end
	end
end
