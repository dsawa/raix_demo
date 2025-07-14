# frozen_string_literal: true

require_relative 'config/application'
require_relative 'raix_demo/agent'

class AgentDemo
  def self.run
    puts '🚀 Ruby Agent Demo with RAIX'
    puts '=' * 50

    agent = Agent.build(openai: 'gpt-4o')

    # Example 1: Simple question
    puts "\nExample 1: Simple question"
    puts '-' * 30
    response = agent.run('What is 2 + 2?')
    puts "Response: #{response}"

    # Example 2: Palindrome check
    puts "\nExample 2: Palindrome check"
    puts '-' * 30
    response = agent.run("Check if 'racecar' is a palindrome")
    puts "Response: #{response}"

    # Example 3: Time in timezone
    puts "\nExample 3: Current time"
    puts '-' * 30
    response = agent.run('What time is it in New York?')
    puts "Response: #{response}"

    # Example 4: String reversal
    puts "\nExample 4: String reversal"
    puts '-' * 30
    response = agent.run("Reverse the string 'Hello World'")
    puts "Response: #{response}"

    # Example 5: Web search
    puts "\nExample 5: Web search"
    puts '-' * 30
    response = agent.run('Search for information about Ruby programming language')
    puts "Response: #{response}"

    # Example 6: Visit webpage
    puts "\nExample 6: Visit webpage"
    puts '-' * 30
    response = agent.run('Visit https://kotyharcuja.pl/o-nas/ and summarize the content')
    puts "Response: #{response}"

    puts "\nDemo completed! Hope you enjoyed it! 🎉"
  end

  def self.interactive
    puts '🚀 Interactive Ruby Agent with RAIX'
    puts '=' * 50
    puts "Type 'exit' or 'quit' to stop"
    puts "Type 'help' for available commands"

    agent = Agent.build(openai: 'gpt-4o')

    loop do
      print "\n> "
      input = gets.chomp

      case input.downcase
      when 'exit', 'quit'
        puts 'Goodbye!'
        break
      when 'help'
        puts help_text
      when ''
        next
      else
        begin
          response = agent.run(input)
          puts "\nResponse:"
          puts response
        rescue StandardError => e
          puts "Error: #{e.message}"
        end
      end
    end
  end

  def self.help_text
    <<~HELP

      Available commands:
      - Ask any question or give instructions
      - The agent has access to these tools:
        * palindrome_check: Check if text is a palindrome
        * string_reversal: Reverse text
        * get_current_time_in_timezone: Get time in any timezone
        * web_search: Search the web
        * visit_webpage: Read webpage content

      Examples:
      - "Check if 'madam' is a palindrome"
      - "What time is it in Tokyo?"
      - "Reverse the string 'hello'"
      - "Search for Ruby on Rails tutorials"
      - "Visit https://ruby-lang.org and summarize it"

      Commands:
      - help: Show this help
      - exit/quit: Exit the program
    HELP
  end
end

App.boot

if ARGV.include?('--interactive') || ARGV.include?('-i')
  AgentDemo.interactive
else
  AgentDemo.run
end
