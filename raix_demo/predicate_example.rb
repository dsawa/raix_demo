# frozen_string_literal: true

# With Raix::Predicate we need to use .ask instead of .chat_completion
# ai = PredicateExample.new
# ai.ask("Is the 'samochód' a word from Polish language?")

class PredicateExample
  include Raix::Predicate

  def initialize
    @model = Raix.configuration.model
  end

  yes? do |explanation|
    puts "That's true: #{explanation}"
  end

  no? do |explanation|
    puts "That's false: #{explanation}"
  end

  maybe? do |explanation|
    puts "I'm not sure: #{explanation}"
  end
end
