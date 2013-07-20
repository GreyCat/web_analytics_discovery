require 'grabberutils'

class MailRu
	include GrabberUtils

	def run(url)
		@page = download(url)
		run_id(find_id)
	end

	def find_id
		if @page =~ /<a href="http:\/\/top.mail.ru\/jump\?from=(\d+)".*><img src="http:\/\/.*.top.mail.ru\/counter/
			$1
		else
			nil
		end
	end

	def run_id(id)
		return nil unless id
		r = {}

		doc = download("http://top.mail.ru/visits.csv?id=#{id}&period=0&date=&back=30&", 'windows-1251').split(/\n/)[4..-1]
		sum_v = 0
		sum_pv = 0
		doc.each { |l|
			#"Дата";"Посетители";"Новые посетители";"Ядро";"Хосты";"Просмотры";"Глубина"
			date, v, new_v, core_v, hosts, pv, depth = l.split(/;/)
			sum_v += v.to_i
			sum_pv += pv.to_i
		}

		#doc = download("http://top.mail.ru/visits?id=#{id}")

		r[:visitors_day] = sum_v / doc.size
		r[:pv_day] = sum_pv / doc.size
		r[:pv_mon] = sum_pv
		return r
	end
end
