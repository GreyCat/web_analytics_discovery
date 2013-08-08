# -*- coding: UTF-8 -*-

require 'web_analytics_discovery/grabberutils'

require 'date'

module WebAnalyticsDiscovery
class TNS
	include GrabberUtils

	def initialize
		# This one requires xlsx2csv utility
		begin
			parser_version = `xlsx2csv --version`
		rescue Errno::ENOENT
			raise 'xlsx2csv not available: unable to run TNS report discovery'
		end

		# And an unzip utility
		begin
			unzip_version = `unzip -v`
		rescue Errno::ENOENT
			raise 'unzip not available: unable to run TNS report discovery'
		end
	end

	def parse_report
		zipped = ensure_download
		unzipped = ensure_unpack(zipped)
		converted = ensure_convert(unzipped)

		@report = {}
		File.open(converted).each_line { |l|
			c = l.chomp.split(/\t/)

			# Skip headers
			next if c.size < 5

			# Skip table column headers
			next if c[0].empty?

			# Skip generic audience info columns
			next if c[1].empty?

			# Downcase URL and calculate proper monthly visitors
			@report[c[1].downcase] = (c[2].to_f * 1000).to_i
		}
	end

	MAX_TRIES = 5

	def ensure_download
		date = Date.today.prev_month

		MAX_TRIES.times {
			begin
				fn = download_file(TNS.url_for_report(date))
				return fn
			rescue DownloadError
				# ignore, we'll try another month
			end
			date = date.prev_month
		}
	end

	def self.url_for_report(date)
		date.strftime('http://www.tns-global.ru/media/content/B7525726-B5E1-4C12-BE25-4C543F42F3EE/!Web%%20Index%%20Report%%20%Y%m.zip')
	end

	def ensure_unpack(zipped)
		unzipped = "#{CACHE_DIR}/tns_#{File.basename(zipped)}.xlsx"
		unless File.exists?(unzipped)
			system("unzip -pq '#{zipped}' *.xlsx >'#{unzipped}'")
			raise 'Unable to unpack TNS report' unless $?.exitstatus == 0
		end
		return unzipped
	end

	def ensure_convert(unzipped)
		converted = "#{CACHE_DIR}/#{File.basename(unzipped)}.tsv"
		unless File.exists?(converted)
			system("xlsx2csv -d tab -s 1 '#{unzipped}' >'#{converted}'")
			raise 'Unable to convert TNS report to .tsv' unless $?.exitstatus == 0
		end
		return converted
	end

	def run(url)
		run_id(find_id(url))
	end

	def find_id(url)
		URI.parse(url).host
	end

	def run_id(id)
		parse_report unless @report
		v = @report[id]
		return v ? {:id => id, :visitors_mon => v} : nil
	end
end
end
