require 'grabberutils'

class GoogleAnalytics
	include GrabberUtils

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /_gat\._getTracker\("([^"]+)"\)/
			$1
		else
			nil
		end
	end

	def run_id(id)
		return nil unless id
		r = {:id => id}
		return r
	end
end
