require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

# TNS module requires us to download TNS report and parse it. As TNS
# site could be unstable, it's better to run this process separately,
# before all other tasks, with a more verbose output settings to see
# what's going on.
task :preload do
  require 'web_analytics_discovery'
  WebAnalyticsDiscovery::download_debug = :stdout
  d = WebAnalyticsDiscovery::TNS.new
  d.parse_report
end
