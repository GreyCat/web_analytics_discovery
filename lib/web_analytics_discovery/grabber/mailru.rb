# -*- coding: utf-8 -*-

require 'web_analytics_discovery/grabberutils'

module WebAnalyticsDiscovery
class MailRu
	include GrabberUtils

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		case @page
		when /<a [^>]*href="http:\/\/top\.mail\.ru\/jump\?from=(\d+)".*>\s*<img src="http:\/\/.*.top.mail.ru\/counter/m,
			/<img src=['"]?http:\/\/top\.list\.ru\/counter\?id=(\d+)/,
			/<img src=['"]?http:\/\/.*top\.mail\.ru\/counter\?js=na;id=(\d+)/,
			/_tmr.push\(\{id:\s*['"](\d+)['"]/
			$1.to_i
		else
			nil
		end
	end

	def run_id(id)
		return nil unless id
		r = {:id => id}

		#doc = download("http://top.mail.ru/visits?id=#{id}")

		# Analyze daily report
		doc = download("http://top.mail.ru/visits.csv?id=#{id}&period=0&date=&back=30&", 'windows-1251').split(/\n/)
		return run_id_html_rating(r, id) if doc.empty?
		doc = doc[4..-1]

		sum_v = 0
		sum_pv = 0
		doc.each { |l|
			#"Дата";"Посетители";"Новые посетители";"Ядро";"Хосты";"Просмотры";"Глубина"
			date, v, new_v, core_v, hosts, pv, depth = l.split(/;/)
			sum_v += v.to_i
			sum_pv += pv.to_i
		}

		r[:visitors_day] = sum_v / doc.size
		r[:pv_day] = sum_pv / doc.size

		# Analyze weekly report
		doc = download("http://top.mail.ru/visits.csv?id=#{id}&period=1&date=&back=98&", 'windows-1251').split(/\n/)
		return r if doc.empty?
		date, v, new_v, core_v, hosts, pv, depth = doc[4].split(/;/)
		r[:visitors_week] = v.to_i
		r[:pv_week] = pv.to_i

		# Analyze monthly report
		doc = download("http://top.mail.ru/visits.csv?id=#{id}&period=2&date=&back=395&", 'windows-1251').split(/\n/)
		return r if doc.empty?
		date, v, new_v, core_v, hosts, pv, depth = doc[4].split(/;/)
		r[:visitors_mon] = v.to_i
		r[:pv_mon] = pv.to_i

		return r
	end

	# Parse semi-closed rating when normal full CSV export is not available
	def run_id_html_rating(r, id)
		doc = download("http://top.mail.ru/rating?id=#{id}", 'windows-1251')

		today = []
		doc.gsub(/<td class="l_col">Сегодня<\/td>.*?<td class="r_col"><b>([0-9,]+)<\/b>/m) { today << $1.gsub(/,/, '').to_i }

		week = []
		doc.gsub(/<td class="l_col">Неделя<\/td>.*?<td class="r_col"><b>([0-9,]+)<\/b>/m) { week << $1.gsub(/,/, '').to_i }

		month = []
		doc.gsub(/<td class="l_col">Месяц<\/td>.*?<td class="r_col"><b>([0-9,]+)<\/b>/m) { month << $1.gsub(/,/, '').to_i }

		# Non-normal number of matches? That's weird, bail out
		return r unless today.length == 3 and week.length == 3 and month.length == 3

		r[:visitors_day], r[:pv_day], r[:ip_day] = today
		r[:visitors_week], r[:pv_week], r[:ip_week] = week
		r[:visitors_mon], r[:pv_mon], r[:ip_mon] = month

		return r
	end
end
end
