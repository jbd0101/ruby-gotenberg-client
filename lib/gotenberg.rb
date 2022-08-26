# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'faraday'
require 'faraday/multipart'

Faraday.default_adapter = :net_http

require 'tempfile'
require_relative "gotenberg/version"

module Gotenberg
  class Error < StandardError; end
  # Your code goes here...
  class Client
    def initialize(api_url)
      @api_url = api_url
    end

=begin
  write the pdf file in output
  pre:
    render, string, html that needs to be converted
    output, output file
  post:
    pdf in the output file
    true if everything ok

=end
  def html(render,output)
      return false unless self.up?


      ind_html = Tempfile.new('index.html')
      ind_html.write(render)
      ind_html.rewind
      payload = {
        "index.html": Faraday::Multipart::FilePart.new(
            File.open(ind_html),
            'text/html',
            "index.html"
          )
      }
      url= "#{@api_url}/forms/chromium/convert/html"

    conn = Faraday.new(url) do |f|
      f.request :multipart, flat_encode: true
      f.adapter :net_http
    end

    response = conn.post(url, payload)
    ind_html.close
    ind_html.unlink
    output.write(response.body.force_encoding("utf-8"))
    return true

  end

    def up?
      begin
        uri = URI.parse("#{@api_url}/health")
        request = Net::HTTP::Get.new(uri)
        req_options = {use_ssl: uri.scheme == "https",}

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        if response.code == "200" && JSON.parse(response.body)["status"]=="up"
          return true
        end
      rescue StandardError => e
        return false
      end
    end
  end
end
