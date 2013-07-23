# -*- coding: utf-8 -*-

require 'web_analytics_discovery/grabberutils'

class Rambler
	include GrabberUtils

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /_top100q.push\(\["setAccount", "(\d+)"\]\)/
			$1
		when /<a href="http:\/\/top100\.rambler\.ru\/cgi-bin\/stats_top100\.cgi\?(\d+)"/
			$1
		when /<script.*src="http:\/\/counter\.rambler\.ru\/top100\.jcn\?(\d+)">/
			$1
                when /<img src="http:\/\/counter\.rambler\.ru\/top100\.cnt\?(\d+)"/
			$1
		else
			nil
		end
	end

	def run_id(id)
		return nil unless id
		r = {:id => id}

#		doc = download("http://top100.rambler.ru/resStats/#{id}/")
		doc = download("http://top100.rambler.ru/resStats/#{id}/?_export=csv&_id=#{id}&_page=0", 'UTF-16LE')

		# Сегодня, Вчера, За 7 дней, На прошлой неделе, За 30 дней, В прошлом месяце

		if doc =~ /уникальных\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/
			r[:visitors_day] = $2.to_i
			r[:visitors_week] = $4.to_i
			r[:visitors_mon] = $6.to_i
		end

		if doc =~ /Визитов \(сессий\)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/
			r[:visits_day] = $2.to_i
			r[:visits_week] = $4.to_i
			r[:visits_mon] = $6.to_i
		end

		if doc =~ /Просмотров страниц\n\s*всего\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/
			r[:pv_day] = $2.to_i
			r[:pv_week] = $4.to_i
			r[:pv_mon] = $6.to_i
		end

		return r
	end
end
