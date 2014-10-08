# -*- coding: utf-8 -*-

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

	# Parsing TNS report involves the following stages:
	#
	# 1. Download non-empty "directory" page from their web site
	# for a current year (keep requesting older years if we keep
	# getting empty output, bail out on HTTP error)
	#
	# 2. Download first (most recent) report listed on that "directory" page
	#
	# 3. Unpack (unzip) downloaded report file; it's a zip that
	# contains multiple files, including single .xlsx file with
	# raw data.
	#
	# 4. Convert .xlsx file into something more readable (CSV)
	# with external utility.
	#
	# 5. Parse resulting CSV report into memory (it's relatively
	# short - as of 2014-10, TNS lists only ~500 sites)
	def parse_report
		report_url = query_directory
		zipped = download_file(report_url)
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
			visitors = (c[2].to_f * 1000).to_i
			url = c[1].downcase.gsub(/ \(сайт\)$/, '')

			@report[url] = visitors
		}
	end

	MAX_TRIES = 5

	def query_directory
		y = Date.today.year
		MAX_TRIES.times {
			dir = download("http://www.tns-global.ru/services/media/media-audience/internet/information/?arrFilter_pf%5BYEAR%5D=#{y}&set_filter=%D0%9F%D0%BE%D0%BA%D0%B0%D0%B7%D0%B0%D1%82%D1%8C&set_filter=Y")
			if dir =~ /<a href="(\/services\/media\/media-audience\/internet\/information\/\?download=\d+&date=.*?)">/
				return "http://www.tns-global.ru#{$1}"
			end
			y -= 1
		}
		raise 'Unable to query report directory - not a single report found'
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
