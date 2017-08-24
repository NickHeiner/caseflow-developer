require 'httparty'
require 'json'

module Graphql
  def Graphql.query(query_str, variables, on_error)
    Rails.logger.debug "Making graphql query: #{query_str} with variables #{variables}"

    begin
      response = HTTParty.post(
        'https://api.github.com/graphql', 
        headers: {
          'Authorization' => "bearer #{ENV['GITHUB_ACCESS_TOKEN']}", 
          'User-Agent' => 'HTTParty'
        }, 
        body: {
          query: query_str,
          variables: variables
        }.to_json,
        timeout: 1
      ).parsed_response
    rescue Net::OpenTimeout 
      on_error
      return
    end

    Rails.logger.debug "Got graphql response: #{response}"

    if response['errors']
      raise "GraphQL query response had errors: #{response['errors']}"
    end

    response['data']
  end
end

