# -*- coding: utf-8 -*-
# Name::      Automatic::Ruby
# Author::    774 <http://id774.net>
# Created::   Feb 18, 2012
# Updated::   Jun 27, 2013
# Copyright:: Copyright (c) 2012-2013 Automatic Ruby Developers.
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic
  require 'automatic/environment'
  require 'automatic/recipe'
  require 'automatic/pipeline'
  require 'automatic/log'
  require 'automatic/feed_parser'

  VERSION = "13.6.0"
  USER_DIR = "/.automatic"

  class << self
    attr_accessor :root_dir

    def run(args = { })
      self.root_dir = args[:root_dir]
      self.user_dir = args[:user_dir]
      Automatic::Pipeline.run(args[:recipe])
    end

    def plugins_dir
      File.join(@root_dir, "plugins")
    end

    def config_dir
      File.join(@root_dir, "config")
    end

    def user_dir
      @user_dir
    end

    def user_dir=(_user_dir)
      if ENV["AUTOMATIC_RUBY_ENV"] == "test" && !(_user_dir.nil?)
        @user_dir = _user_dir
      else
        @user_dir = File.expand_path("~/") + USER_DIR
      end
    end

    def user_plugins_dir
      File.join(@user_dir, "plugins")
    end
  end

end
