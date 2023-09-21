require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/concern'

require_relative 'kimurai/version'
require_relative 'kimurai/cli'

require_relative 'kimurai/core_ext/numeric'
require_relative 'kimurai/core_ext/string'
require_relative 'kimurai/core_ext/array'
require_relative 'kimurai/core_ext/hash'

# => Discovered roles
require_relative 'kimurai/concerns/loggable'
require_relative 'kimurai/browser_builder'
require_relative 'kimurai/base_helper'
require_relative 'kimurai/pipeline'
require_relative 'kimurai/base'

module Kimurai

  # Set the global configuration options
  def self.configure(&block)
    block.call(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.env
    ENV.fetch("KIMURAI_ENV") { "development" }
  end

  def self.time_zone
    ENV["TZ"]
  end

  def self.time_zone=(value)
    ENV.store("TZ", value)
  end

  def self.list
    Base.descendants.map do |klass|
      next unless klass.name
      [klass.name, klass]
    end.compact.to_h
  end

  def self.find_by_name(name)
    return unless name
    Base.descendants.find { |klass| klass.name == name }
  end
end
