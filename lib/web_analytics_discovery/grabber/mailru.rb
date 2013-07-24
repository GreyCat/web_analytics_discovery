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
		return r if doc.empty?
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
		r[:visitors_week] = v
		r[:pv_week] = pv

		# Analyze monthly report
		doc = download("http://top.mail.ru/visits.csv?id=#{id}&period=2&date=&back=395&", 'windows-1251').split(/\n/)
		return r if doc.empty?
		date, v, new_v, core_v, hosts, pv, depth = doc[4].split(/;/)
		r[:visitors_mon] = v
		r[:pv_mon] = pv

		return r
	end
end
end
