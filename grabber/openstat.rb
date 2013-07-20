require 'grabberutils'

class Openstat
	include GrabberUtils

	BIG_SITE_ID = 601119

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /<span id="(?:openstat|spylog)(\d+)"><\/span>/
			$1
		else
			nil
		end
	end

	def run_id(id)
		r = {}
		doc = download("http://rating.openstat.ru/site/#{id}")
		r[:visitors_day], r[:visits_day], r[:pv_day] = grab(doc, 'osb-rating_site-e-table-col-m-day')
		r[:visitors_mon], r[:visits_mon], r[:pv_mon] = grab(doc, 'osb-rating_site-e-table-col-m-month')
		return r
	end

	def grab(doc, classname)
		a = []
		doc.gsub(/#{classname}">([^<]+)<\/td>/) {
			r = $1
			r.gsub!(/&nbsp;/, '')
			a << r.to_i
		}
		return a
	end
end
