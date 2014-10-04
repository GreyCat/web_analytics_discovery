require 'web_analytics_discovery/version'

require 'web_analytics_discovery/grabber/alexa'
require 'web_analytics_discovery/grabber/googleanalytics'
require 'web_analytics_discovery/grabber/liveinternet'
require 'web_analytics_discovery/grabber/mailru'
require 'web_analytics_discovery/grabber/openstat'
require 'web_analytics_discovery/grabber/quantcast'
require 'web_analytics_discovery/grabber/rambler'
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
end
