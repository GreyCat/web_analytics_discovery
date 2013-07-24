# -*- coding: utf-8 -*-

require 'web_analytics_discovery/grabberutils'

module WebAnalyticsDiscovery
class Rambler
	include GrabberUtils

	SEC_PER_DAY = 24 * 60 * 60

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /_top100q.push\(\["setAccount", "(\d+)"\]\)/,
			/<a href="http:\/\/top100\.rambler\.ru\/cgi-bin\/stats_top100\.cgi\?(\d+)"/,
			/<script.*src="http:\/\/counter\.rambler\.ru\/top100\.jcn\?(\d+)">/,
			/<img src="http:\/\/counter\.rambler\.ru\/top100\.cnt\?(\d+)"/
			$1.to_i
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

		# Plan B: if proper CSV export failed, we'll try to look up information in rating catalogue
		unless r[:visitors_day]
			now = Time.now
			r[:visitors_day], r[:pv_day] = parse_rating_table("http://top100.rambler.ru/?range=#{spec_yesterday(now)}&stat=1&statcol=1%2C2&query=#{id}", id)
			r[:visitors_week], r[:pv_week] = parse_rating_table("http://top100.rambler.ru/?range=#{spec_last_week(now)}&stat=1&statcol=1%2C2&query=#{id}", id)
			r[:visitors_mon], r[:pv_mon] = parse_rating_table("http://top100.rambler.ru/?range=#{spec_last_month(now)}&stat=1&statcol=1%2C2&query=#{id}", id)
		end

		return r
	end

	def parse_rating_table(url, id)
		doc = download(url)
		if doc =~ /<tr>(\s*<td align="right">.*?<a href="\/resStats\/#{id}\/.*?)<\/tr>/m
			table_row = $1
			if table_row =~ /<td align="right">([0-9&nbsp;]+)<\/td>\s*<td class="last" align="right">([0-9&nbsp;]+)<\/td>/m
				v = $1
				pv = $2
				v = v.gsub(/&nbsp;/, '').to_i
				pv = pv.gsub(/&nbsp;/, '').to_i
				return [v, pv]
			end
		end
		return [nil, nil]
	end

	def spec_yesterday(now)
		(now - SEC_PER_DAY).strftime('%d.%m.%Y')
	end

	def spec_last_week(now)
		wday = now.wday
		wday = 7 if wday == 0
		end_week = now - (wday * SEC_PER_DAY)
		start_week = end_week - 6 * SEC_PER_DAY
		"#{start_week.strftime('%d.%m.%Y')}+-+#{end_week.strftime('%d.%m.%Y')}"
	end

	def spec_last_month(now)
		this_month_1 = Time.new(now.year, now.month, 1)
		last_month_end = this_month_1 - SEC_PER_DAY
		last_month_start = Time.new(last_month_end.year, last_month_end.month, 1)
		"#{last_month_start.strftime('%d.%m.%Y')}+-+#{last_month_end.strftime('%d.%m.%Y')}"
	end
end
end
