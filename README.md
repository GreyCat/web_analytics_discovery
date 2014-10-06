# web_analytics_discovery

This gem provides a set of tools for discovery and export of data from
popular web analytics tools.

The supported web analytics systems are:

* Alexa
* Google Analytics
* LiveInternet
* Mail.ru
* Openstat
* Quantcast
* Rambler Top100
* Yandex Metrika

## The problem

Given a particular site URL (i.e. `http://example.com/`), we'd like to
know audience statistics on that particular site (i.e. how many unique
people visit this site per day, per week, per month, how many page views
do they do, etc).

## The solution

Many sites use web analytics tools to measure audience stats. Quite
often, these statistics are even available for public, although one needs to know:

* which particular web analytics system a given site uses
* what is this site's ID in that web analytics system

Answering these question usually requires tedious manual process:

* Look up site's HTML code
* Locate JavaScript code / tags / calls to web analytics system
* Identify this system
* Identify site's ID in the code / calls
* Go to web analytics's system site or API and get desired statistics

This gem tries automate these tasks, looking up all the info and
retrieving information from web analytics systems. Exported data can
be accessed in simple tabular form or programmatically, as a hash,
using API.

## Installation

### From RubyGems repository

* Make sure you have Ruby and RubyGems
* Just run `gem install web_analytics_discovery`

### Manually from source

* Clone this repository / download snapshot
* `gem build web_analytics_discovery.gemspec`
* `gem install ./web_analytics_discovery-*.gem`

## Basic usage

For basic usage, a simple executable `web_analytics_discover` is
provided and installed during gem installation. It can be run with one
or several URLs as command-line arguments and it will produce a simple
summary table for each of the URLs.

Example:

    $ web_analytics_discover http://kp.ru/
                        |                      id|      v/day|      s/day|     pv/day|      v/mon|      s/mon|     pv/mon
    alexa               |                   kp.ru|        N/A|        N/A|    1477599|    6825125|        N/A|   44974428
    googleanalytics     |           UA-23870775-1|        N/A|        N/A|        N/A|        N/A|        N/A|        N/A
    liveinternet        |                        |     597956|     745757|    1787863|   10585641|   21308436|   49775501
    mailru              |                  294001|     756600|        N/A|    2230674|   15086634|        N/A|   73738178
    openstat            |                 2026010|     983579|    1195306|    2823114|   14757845|   28953554|   69970669
    quantcast           |                wd:ru.kp|        N/A|        N/A|        N/A|      36300|        N/A|        N/A
    rambler             |                   17841|    1048235|    1287761|    3015270|   15550162|   31307958|   75869606
    yandexmetrika       |                 1051362|     259987|     310983|     727833|        N/A|        N/A|   22153416

## API usage

One can easily use web analytics discovery using simple API. Every web
analytics service is supported by a separate class named after that
service in `WebAnalyticsDiscovery` module:

* `Alexa`
* `GoogleAnalytics`
* `LiveInternet`
* `MailRu`
* `Openstat`
* `Quantcast`
* `Rambler`
* `YandexMetrika`

One can use it like that:

    require 'web_analytics_discovery'
    d = WebAnalyticsDiscovery::MailRu.new
    result = d.run('http://kp.ru/')

`result` will look like that:

    {:id=>294001,
     :visitors_day=>756600,
     :pv_day=>2230674,
     :visitors_week=>3365344,
     :pv_week=>13102096,
     :visitors_mon=>15086634,
     :pv_mon=>73738178}

Some values might be missing if it's not possible to retrieve them
from a given service.

## Licensing and usage

Copyright (C) 2013-2014  Mikhail Yakshin <greycat@altlinux.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Affero General Public License for more details.

Please consult LICENSE file for more details and full license text.
