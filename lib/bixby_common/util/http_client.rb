
require 'curb'
require 'multi_json'

module Bixby

# Utilities for creating HTTP Clients. Just a thin wrapper around curb and JSON
# for common cases.
module HttpClient

  # Execute an HTTP GET request to the given URL
  #
  # @param [String] url
  # @return [String] Contents of the response's body
  def http_get(url)
    Curl::Easy.http_get(url).body_str
  end

  # Execute an HTTP GET request (see #http_get) and parse the JSON response
  #
  # @param [String] url
  # @return [Object] Result of calling JSON.parse() on the response body
  def http_get_json(url)
    MultiJson.load(http_get(url))
  end

  # Convert a Hash into a Curl::Postfield array for use with Curb
  #
  # @param [Hash] data
  # @return [Array<Curl::PostField>]
  def create_post_data(data)
    if data.kind_of? Hash then
      data = data.map{ |k,v| Curl::PostField.content(k, v) }
    end
    data
  end

  # Execute an HTTP POST request to the given URL
  #
  # @param [String] url
  # @param [Hash] data  Key/Value pairs to POST
  # @return [String] Contents of the response's body
  def http_post(url, data)
    return Curl::Easy.http_post(url, create_post_data(data)).body_str
  end

  # Execute an HTTP POST request (see #http_get) and parse the JSON response
  #
  # @param [String] url
  # @param [Hash] data  Key/Value pairs to POST
  # @return [Object] Result of calling JSON.parse() on the response body
  def http_post_json(url, data)
    MultiJson.load(http_post(url, data))
  end

  # Execute an HTTP post request and save the response body
  #
  # @param [String] url
  # @param [Hash] data  Key/Value pairs to POST
  # @return [void]
  def http_post_download(url, data, dest)
    File.open(dest, "w") do |io|
      c = Curl::Easy.new(url)
      c.on_body { |d| io << d; d.length }
      c.http_post(data)
    end
  end

end # HttpClient

end # Bixby
