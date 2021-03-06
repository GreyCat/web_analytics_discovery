require 'fileutils'
require 'digest/md5'

module GrabberUtils
	CACHE_DIR = 'cache'
	USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; rv:22.0) Gecko/20100101 Firefox/22.0'

	class DownloadError < Exception; end

	def download(url, encoding = 'UTF-8', options = {})
		fn = download_file(url, options)

		# Truly horrible hack to work around Ruby 1.9.2+ strict handling of invalid UTF-8 characters
		s = File.read(fn)
		s.encode!('UTF-16', encoding, :invalid => :replace, :replace => '?')
		s.encode!('UTF-8', 'UTF-16', :invalid => :replace, :replace => '?')
	end

	# Downloads a file, returns filename in cache directory
	def download_file(url, options = {})
		FileUtils.mkdir_p(CACHE_DIR)
		localfile = options['localfile'] || mangle_url(url)
		fn = CACHE_DIR + '/' + localfile
		unless FileTest.exists?(fn)
			opt = {
				'user-agent' => USER_AGENT,
				'load-cookies' => 'cookies.txt',
				'save-cookies' => 'cookies.txt',
			}

			if options['Referer']
				opt['referer'] = options['Referer']
			end

			case WebAnalyticsDiscovery::download_debug
			when :file
				opt['append-output'] = 'wget.log'
			when :stdout
				# default, do nothing
			when :ignore
				opt['quiet'] = true
			else
				raise "Invalid value for download_debug: #{@download_debug.inspect}"
			end

			opt = opt.map { |k, v|
				if v == true
					"--#{k}"
				else
					"--#{k}='#{v}'"
				end
			}.join(' ')
			system("wget --keep-session-cookies -O'#{fn}' #{opt} '#{url}'")
			if $?.exitstatus != 0
				File.delete(fn)
				raise DownloadError.new
			end
		end

		return fn
	end

	def mangle_url(url)
		if url.length < 200
			f = url.gsub(/[:\/]/, '_')
		else
			f = Digest::MD5.hexdigest(url)
		end
	end

	# Average number of days per month
	AVG_DAYS_IN_MONTH = 365.25 / 12
end
