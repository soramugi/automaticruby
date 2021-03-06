# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Subscription::Text
# Author::    soramugi <http://soramugi.net>
# Created::   May 6, 2013
# Updated::   May 6, 2013
# Copyright:: Copyright (c) 2012-2013 Automatic Ruby Developers.
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class TextFeed
    def initialize
      @link     = 'http://dummy'
      @title    = 'dummy'
    end

    def link
      @link
    end

    def title
      @title
    end

    def set_link(link)
      @link = link
    end

    def set_title(title)
      @title = title
    end
  end

  class SubscriptionText

    def initialize(config, pipeline=[])
      @config   = config
      @pipeline = pipeline

      unless @config.nil?
        @dummyfeeds = []
        unless @config['titles'].nil?
          @config['titles'].each {|title|
            textFeed = TextFeed.new
            textFeed.set_title(title)
            @dummyfeeds << textFeed
          }
        end

        unless @config['urls'].nil?
          @config['urls'].each {|url|
            textFeed = TextFeed.new
            textFeed.set_link(url)
            @dummyfeeds << textFeed
          }
        end

        unless @config['feeds'].nil?
          @config['feeds'].each {|feed|
            textFeed = TextFeed.new
            textFeed.set_title(feed['title']) unless feed['title'].nil?
            textFeed.set_link(feed['url']) unless feed['url'].nil?
            @dummyfeeds << textFeed
          }
        end
      end

    end

    def run
      if @dummyfeeds != []
        @pipeline << Automatic::FeedParser.create(@dummyfeeds)
      end

      @pipeline
    end
  end
end
