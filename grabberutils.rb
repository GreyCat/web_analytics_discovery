module GrabberUtils
	CACHE_DIR = 'cache'

	def download(url, encoding = 'UTF-8')
		FileUtils.mkdir_p(CACHE_DIR)
		fn = CACHE_DIR + '/' + mangle_url(url)
		unless FileTest.exists?(fn)
			system("wget --user-agent='Mozilla/5.0 (Windows NT 6.1; rv:22.0) Gecko/20100101 Firefox/22.0' -O'#{fn}' '#{url}'")
			raise 'Download error' if $?.exitstatus != 0
		end

		# Truly horrible hack to work around Ruby 1.9.2+ strict handling of invalid UTF-8 characters
		s = File.read(fn)
		s.encode!('UTF-16', encoding, :invalid => :replace, :replace => '?')
		s.encode!('UTF-8', 'UTF-16', :invalid => :replace, :replace => '?')
	end

	def mangle_url(url)
		url.gsub(/[:\/]/, '_')
	end
end
