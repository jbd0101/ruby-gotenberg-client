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
    def html(render,assets=[])
      uri = URI("#{@api_url}/forms/chromium/convert/html")
      request = Net::HTTP::Post.new(uri)
      ind_html = Tempfile.new(['index','.html'])
      ind_html.write(render)
      ind_html.rewind
      form_data = [["index.html",ind_html]]


      assets.each do |file|
        form_data<<["files",file]
      end

      request.set_form form_data, 'multipart/form-data'
      req_options = {use_ssl: uri.scheme == "https",}

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http| # pay attention to use_ssl if you need it
        http.request(request)
      end
      p "3"
      p response
      p response.body
      ind_html.close
      ind_html.unlink
      File.write("test.pdf",response.body)
    end
=end
  def html(render)
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
      File.write("test.pdf",response.body,encoding: 'ascii-8bit')

  end

    def up?
      uri = URI.parse("#{@api_url}/health")
      request = Net::HTTP::Get.new(uri)
      req_options = {use_ssl: uri.scheme == "https",}

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      if response.code == "200" && JSON.parse(response.body)["status"]=="up"
        return true
      end
      false
    end
  end
end
