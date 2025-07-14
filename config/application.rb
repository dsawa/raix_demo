# frozen_string_literal: true

require 'dotenv/load'
require 'bundler/setup'
require 'raix'
require 'faraday'
require 'faraday/retry'

if ENV['DEBUG']
  require 'debug'
  require 'pry'
end

ENV['APP_ENV'] ||= 'development'

ENVIRONMENT = ENV.fetch('APP_ENV')

Bundler.require(:default, ENVIRONMENT.to_sym)

class App
  class << self
    attr_accessor :env, :root, :logger

    def boot
      load_settings
      load_initializers
      eager_load
    end

    def load_settings
      self.env = ENVIRONMENT
      self.root = Pathname.new(File.expand_path('../', File.dirname(__FILE__)))
      self.logger = Logger.new($stdout).tap do |logger|
        logger.level = ENV['DEBUG'].present? ? Logger::DEBUG : Logger::INFO

        logger.formatter = Logger::Formatter.new
      end
    end

    def load_initializers
      [File.join(root, 'config', 'initializers', '**', '*.rb')].each do |dir|
        Dir.glob(dir).each { |file| require file }
      end
    end

    def eager_load
      [File.join(root, 'raix_demo', '**', '*.rb')].each do |dir|
        Dir.glob(dir).each { |file| require file }
      end
    end
  end
end
