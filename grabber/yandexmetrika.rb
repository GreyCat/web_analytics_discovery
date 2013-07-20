# -*- coding: UTF-8 -*-

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
		r = {}

#		doc = download("http://top100.rambler.ru/resStats/#{id}/")

		return r
	end
end
