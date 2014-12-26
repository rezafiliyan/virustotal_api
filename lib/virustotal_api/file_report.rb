# encoding: utf-8
require 'rest-client'
require 'json'

module VirustotalAPI
  class FileReport
    attr_reader :report, :report_url

    def initialize(report)
      @report     = report
      @report_url = report.fetch('permalink') { nil }
    end

    # @param [String] md5/sha1/sha256 hash of file resource
    # @param [String] Virustotal API Key
    # @return [VirustotalAPI::FileReport] Report Search Result
    def self.find(resource, api_key)
      response = RestClient.post(api_uri, params(resource, api_key))
      report   = JSON.parse(response.body)

      new(report)
    end

    # @param [String] md5/sha1/sha256 hash of resource
    # @param [String] Virustotal API Key
    # @return [Hash] for POST Request
    def self.params(resource, api_key)
      {
        :resource => resource,
        :apikey   => api_key
      }
    end

    # @return [String] of API URI
    def self.api_uri
      @_api_uri ||= VirustotalAPI::URI + '/file/report'
    end

    # @return [String] instance method of API URI
    def api_uri
      self.class.api_uri
    end

    # @return [Boolean] if report for resource exists
    # 0 => not_present, 1 => exists, -2 => queued_for_analysis
    def exists?
      response_code = report.fetch('response_code') { nil }

      response_code == 1 ? true : false
    end
  end
end
