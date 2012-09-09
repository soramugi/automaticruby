# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Subscription::Twitter
# Author::    774 <http://id774.net>
# Created::   Sep  9, 2012
# Updated::   Sep  9, 2012
# Copyright:: 774 Copyright (c) 2012
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class SubscriptionTwitter
    require 'open-uri'
    require 'nokogiri'
    require 'rss'

    def initialize(config, pipeline=[])
      @config = config
      @pipeline = pipeline
    end

    def run
      @return_feed = []
      @config['urls'].each {|url|
        begin
          Automatic::Log.puts("info", "Parsing: #{url}")
          html = open(url).read
          unless html.nil?
            rss = RSS::Maker.make("2.0") {|maker|
              xss = maker.xml_stylesheets.new_xml_stylesheet
              xss.href = "http://twitter.com"
              maker.channel.about = "http://twitter.com/index.rdf"
              maker.channel.title = "Twitter"
              maker.channel.description = "Twitter"
              maker.channel.link = "http://twitter.com/"
              maker.items.do_sort = true
              doc = Nokogiri::HTML(html)
              doc.xpath("/html/body/div").search('[@class="content"]').each {|content|
                item = maker.items.new_item
                item.title = content.search('[@class="username js-action-profile-name"]').text.to_s
                content.search('[@class="tweet-timestamp js-permalink js-nav"]').each {|node|
                  item.link = "http://twitter.com" + node['href'].to_s
                }
                content.search('[@class="_timestamp js-short-timestamp js-relative-timestamp"]').each {|node|
                  item.date = Time.at(node['data-time'].to_i)
                }
                item.description = content.search('[@class="js-tweet-text"]').text.to_s
              }
            }
            @return_feed << rss
          end
        rescue
          Automatic::Log.puts("error", "Fault in parsing: #{url}")
        end
      }
      @return_feed
    end
  end
end
