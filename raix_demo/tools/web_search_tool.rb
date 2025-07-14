# frozen_string_literal: true

require 'faraday'
require 'json'

module Tools
  class WebSearchTool
    attr_reader :max_results

    def initialize(max_results: 10)
      @max_results = max_results
    end

    def call(query)
      search_web(query)
    rescue StandardError => e
      "Error performing web search: #{e.message}"
    end

    private

    def search_web(query)
      # Simple DuckDuckGo search implementation
      conn = Faraday.new do |f|
        f.request :url_encoded
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end

      # Use DuckDuckGo instant answer API
      response = conn.get('https://api.duckduckgo.com/', {
                            q: query,
                            format: 'json',
                            no_html: '1',
                            skip_disambig: '1'
                          })

      if response.success?
        data = JSON.parse(response.body)

        result = "## Search Results\n\n"

        if data['AbstractText'] && !data['AbstractText'].empty?
          result += "**#{data['Heading']}**\n\n#{data['AbstractText']}\n\n"
          result += "Source: #{data['AbstractURL']}\n\n" if data['AbstractURL']
        end

        if data['RelatedTopics'] && !data['RelatedTopics'].empty?
          result += "**Related Topics:**\n\n"
          data['RelatedTopics'].first(@max_results).each do |topic|
            if topic['Text'] && topic['FirstURL']
              result += "- [#{topic['Text'].split(' - ').first}](#{topic['FirstURL']})\n"
            end
          end
        end

        result.empty? ? "No specific results found for '#{query}'. Try a different search term." : result
      else
        'Search request failed. Please try again.'
      end
    rescue StandardError => e
      "Error performing search: #{e.message}"
    end
  end
end
