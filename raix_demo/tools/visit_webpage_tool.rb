# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'reverse_markdown'

module Tools
  class VisitWebpageTool
    def call(url)
      visit_webpage(url: url)
    rescue StandardError => e
      "Error visiting webpage: #{e.message}"
    end

    private

    def visit_webpage(url)
      url = url[:url] if url.is_a?(Hash)
      url = "https://#{url}" unless url.match?(%r{\Ahttps?://})

      conn = Faraday.new do |f|
        f.request :url_encoded
        f.response :follow_redirects
        f.adapter Faraday.default_adapter
      end

      response = conn.get(url) do |req|
        req.options.timeout = 20
      end

      if response.success?
        doc = Nokogiri::HTML(response.body)
        doc.css('script, style').remove

        markdown_content = ReverseMarkdown.convert(doc.to_s)
        markdown_content = markdown_content.gsub(/\n{3,}/, "\n\n").strip

        truncate_content(markdown_content, 10_000)
      else
        "Error fetching webpage: HTTP #{response.status}"
      end
    rescue Faraday::TimeoutError
      'The request timed out. Please try again later or check the URL.'
    rescue StandardError => e
      "An unexpected error occurred: #{e.message}"
    end

    def truncate_content(content, max_length)
      return content if content.length <= max_length

      truncated = content[0...max_length]
      last_sentence = truncated.rindex(/[.!?]\s/)

      if last_sentence
        truncated[0..last_sentence]
      else
        truncated + '...'
      end
    end
  end
end
