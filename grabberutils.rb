module GrabberUtils
	CACHE_DIR = 'cache'

	def download(url)
		FileUtils.mkdir_p(CACHE_DIR)
		fn = CACHE_DIR + '/' + mangle_url(url)
		unless FileTest.exists?(fn)
			system("wget --user-agent='Mozilla/5.0 (Windows NT 6.1; rv:22.0) Gecko/20100101 Firefox/22.0' -O'#{fn}' '#{url}'")
			raise 'Download error' if $?.exitstatus != 0
		end
		return File.read(fn).encode!('UTF-8', 'UTF-8', :invalid => :replace)
	end

	def mangle_url(url)
		url.gsub(/[:\/]/, '_')
	end
end
