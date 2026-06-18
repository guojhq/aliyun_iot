require 'logger'
require 'active_support'
require 'active_support/core_ext'
require 'rest-client'
require 'nokogiri'
require 'yaml'
require 'openssl'
require "aliyun_iot/version"
require "aliyun_iot/queue"
require "aliyun_iot/topic"
require "aliyun_iot/message"
require "aliyun_iot/product"
require "aliyun_iot/result"

class Hash
  def self.xml_array content, *path
    o = xml_object(content, *path)
    return (o.is_a?(Array) ? o : [o]).reject { |n| n.empty? }
  end

  def self.xml_object content, *path
    h = from_xml(content)
    path.reduce(h) { |memo, node| memo = memo[node] || {} }
  end
end
module AliyunIot
  class ParamsError < StandardError; end

  class << self
    def configuration
      @configuration ||= begin
        if defined? Rails
          config_file = Rails.root.join("config/aliyun_iot.yml")
        else
          config_file = File.expand_path('../../config/aliyun_iot.yml',  __FILE__)
        end

        if (File.exist?(config_file))
          yaml = ERB.new(File.new(config_file).read).result
          config = begin
            YAML.safe_load(yaml, aliases: true)
          rescue ArgumentError
            YAML.safe_load(yaml, [], [], true)
          end
          config = config[Rails.env] if defined? Rails
        end
        OpenStruct.new(config || {access_key_id: "", access_key_secret: "", end_point: "", base_url: "", region_id: "", product_key: ""})
      end
    end

    def configure
      yield(configuration)
    end
  end
end
