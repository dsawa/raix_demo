# frozen_string_literal: true

require 'raix'
require_relative 'tools/visit_webpage_tool'
require_relative 'tools/web_search_tool'

class Agent
  include Raix::ChatCompletion
  include Raix::FunctionDispatch

  attr_reader :max_steps, :current_step, :verbosity_level, :model, :openai

  def initialize(max_steps: 6, verbosity_level: 2, model: Raix.configuration.model, openai: nil)
    @max_steps = max_steps
    @current_step = 0
    @verbosity_level = verbosity_level
    @model = model
    @openai = openai

    setup_tools
  end

  def setup_tools
    @visit_webpage_tool = Tools::VisitWebpageTool.new
    @web_search_tool = Tools::WebSearchTool.new
  end

  function :palindrome_check,
           "A tool that checks if a string is a palindrome. It returns 'YES' if it is, and 'NO' if it isn't.",
           word: { type: 'string', description: 'the string to check' } do |arguments|
    word = arguments[:word]
    cleaned_string = word.downcase.gsub(/[^a-z0-9]/, '')
    result = cleaned_string == cleaned_string.reverse ? 'YES' : 'NO'
    result
  end

  function :string_reversal,
           'A tool that reverses a given string.',
           input_string: { type: 'string', description: 'The string to reverse.' } do |arguments|
    result = arguments[:input_string].reverse
    result
  end

  function :get_current_time_in_timezone,
           'A tool that fetches the current local time in a specified timezone.',
           timezone: { type: 'string',
                       description: "A string representing a valid timezone (e.g., 'America/New_York')." } do |arguments|
    require 'time'
    require 'tzinfo'

    timezone = arguments[:timezone]
    tz = TZInfo::Timezone.get(timezone)
    local_time = tz.now.strftime('%Y-%m-%d %H:%M:%S')
    result = "The current local time in #{timezone} is: #{local_time}"
    log("Time query for #{timezone}: #{local_time}")
    result
  rescue StandardError => e
    error_msg = "Error fetching time for timezone '#{timezone}': #{e.message}"
    log("#{error_msg}")
    error_msg
  end

  function :web_search,
           'Performs a duckduckgo web search based on your query (think a Google search) then returns the top search results.',
           query: { type: 'string', description: 'The search query to perform.' } do |arguments|
    log("Performing web search for: '#{arguments[:query]}'")

    @web_search_tool.call(arguments[:query])
  end

  function :visit_webpage,
           'Visits a webpage at the given url and reads its content as a markdown string. Use this to browse webpages.',
           url: { type: 'string', description: 'The url of the webpage to visit.' } do |arguments|
    log("Visiting webpage: #{arguments[:url]}")
    @visit_webpage_tool.call(arguments[:url])
  end

  function :final_answer,
           'Provides a final answer to the given problem.',
           answer: { type: 'string', description: 'The final answer to the problem' } do |arguments|
    log("Providing final answer: #{arguments[:answer]}")

    stop_tool_calls_and_respond!
    "Final answer: #{arguments[:answer]}"
  end

  def run(user_message, system_prompt: nil)
    @current_step = 0

    transcript.clear

    transcript << if system_prompt
                    { system: system_prompt }
                  else
                    {
                      system: default_system_prompt
                    }
                  end

    transcript << { user: user_message }

    begin
      chat_completion(max_tool_calls: @max_steps, openai: @openai)
    rescue StandardError => e
      error_msg = "An error occurred: #{e.message}"
      log("#{error_msg}")
      error_msg
    end
  end

  def self.build(openai: nil, model: Raix.configuration.model)
    use_model = openai || Raix.configuration.model

    agent = new(openai:, model:)

    log('Agent setup complete!')
    log("Model initialized: #{use_model}")

    agent
  end

  private

  def default_system_prompt
    <<~PROMPT
      You are a helpful AI assistant with access to various tools including:
      - palindrome_check: Check if a string is a palindrome
      - string_reversal: Reverse a string
      - get_current_time_in_timezone: Get current time in any timezone
      - web_search: Search the web using DuckDuckGo
      - visit_webpage: Visit and read webpage content
      - final_answer: Provide your final answer

      Use these tools to help answer questions and solve problems effectively.
      When you have a complete answer, always use the final_answer tool to provide it.
      Be thorough in your research and provide helpful, accurate information.
    PROMPT
  end

  def log(message)
    puts message if @verbosity_level >= 1
  end

  class << self
    private

    def log(message)
      puts message
    end
  end
end
