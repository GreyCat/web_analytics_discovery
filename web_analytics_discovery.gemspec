# -*- encoding: utf-8 -*-

require 'date'

Gem::Specification.new { |s|
  s.name = 'web_analytics_discovery'
  s.version = '0.1'
  s.date = Date.today.to_s

  s.authors = ['Mikhail Yakshin']
  s.email = 'greycat.na.kor@gmail.com'

  s.homepage = 'https://github.com/GreyCat/web_analytics_discovery'
  s.summary = 'Search a site for popular web analytics tools and quickly export current data (site audience, visitors, pageviews)'
  s.license = 'AGPL'
#  s.description = <<-EOF
#EOF

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ['lib']

  s.files = `git ls-files`.split("\n")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
}
