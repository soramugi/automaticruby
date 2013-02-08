# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Subscription::Link
# Author::    774 <http://id774.net>
# Created::   Sep 18, 2012
# Updated::   Feb  8, 2013
# Copyright:: 774 Copyright (c) 2012
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class SubscriptionLink
    require 'open-uri'
    require 'nokogiri'
    require 'rss'

    def initialize(config, pipeline=[])
      @config = config
      @pipeline = pipeline
    end

    def create_rss(url)
      Automatic::Log.puts("info", "Parsing: #{url}")
      html = open(url).read
      unless html.nil?
        rss = Automatic::FeedParser.parse(html)
        sleep @config['interval'].to_i unless @config['interval'].nil?
        @return_feeds << rss
      end
    end

    def run
      @return_feeds = []
      @config['urls'].each {|url|
        retries = 0
        begin
          create_rss(url)
        rescue
          retries += 1
          Automatic::Log.puts("error", "ErrorCount: #{retries}, Fault in parsing: #{url}")
          sleep @config['interval'].to_i unless @config['interval'].nil?
          retry if retries <= @config['retry'].to_i unless @config['retry'].nil?
        end
      }
      @return_feeds
    end
  end
end
