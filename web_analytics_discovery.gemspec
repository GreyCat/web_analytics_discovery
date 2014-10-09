# -*- encoding: utf-8 -*-

require File.expand_path("../lib/web_analytics_discovery/version", __FILE__)
require 'date'

Gem::Specification.new { |s|
  s.name = 'web_analytics_discovery'
  s.version = WebAnalyticsDiscovery::VERSION
  s.date = Date.today.to_s

  s.authors = ['Mikhail Yakshin']
  s.email = 'greycat.na.kor@gmail.com'

  s.homepage = 'https://github.com/GreyCat/web_analytics_discovery'
  s.summary = 'Get web analytics data (site audience, visitors, pageviews) for any given website from a wide array of popular web analytics tools'
  s.license = 'AGPL'
  s.description = <<-EOF
Web Analytics Discovery is a library and command line tool to quickly
get valuable web analytics insights for any given website (for
example, number of unique visitors, number of pageviews per day or per
month).

It works by analyzing site pages, finding snippets of popular web
analytics systems there, extracting their IDs and then automatically
querying that systems for publically available data.

The supported web analytics systems are:

* Alexa
* Google Analytics
* LiveInternet
* Mail.ru
* Openstat
* Quantcast
* Rambler Top100
* Yandex Metrika
EOF

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ['lib']

  s.files = `git ls-files`.split("\n")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec', '~> 3'

  s.add_dependency 'json', '~> 1.8'
}
