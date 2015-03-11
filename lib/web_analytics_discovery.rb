require 'web_analytics_discovery/version'

require 'web_analytics_discovery/grabber/alexa'
require 'web_analytics_discovery/grabber/googleanalytics'
require 'web_analytics_discovery/grabber/liveinternet'
require 'web_analytics_discovery/grabber/mailru'
require 'web_analytics_discovery/grabber/openstat'
require 'web_analytics_discovery/grabber/quantcast'
require 'web_analytics_discovery/grabber/rambler'
require 'web_analytics_discovery/grabber/similarweb'
require 'web_analytics_discovery/grabber/tns'
require 'web_analytics_discovery/grabber/yandexmetrika'

module WebAnalyticsDiscovery
	# Special trickery to get a map of {:service_name => ClassThatImplementsServiceExtraction} magic
	SERVICES = Hash[constants.map { |x|
		possible_class = const_get(x)
		if possible_class.class == Class
			[x.to_s.downcase.to_sym, possible_class]
		else
			nil
		end
	}.delete_if { |v| v.nil? }]

	# Set whatever we should do with download debugging output. Recognized values are:
	# * :ignore - ignores downloader output completely
	# * :stdout - dumps it normally to stdout
	# * :file - dumps it into 'wget.log' file
	@@download_debug = :file

	def self::download_debug
		@@download_debug
	end

	def self::download_debug=(x)
		@@download_debug = x
	end
end
