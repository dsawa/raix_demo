# frozen_string_literal: true

# ai = PromptDeclarationsExample.new
# ai.chat_completion(openai: "gpt-4o")
# ai.transcript << { user: 'Twelve'}

class PromptDeclarationsExample
  include Raix::ChatCompletion
  include Raix::PromptDeclarations

  MAX_SEQUENCE_LOOP = 3

  def initialize
    @until_breakpoint = 0
    @model = Raix.configuration.model
  end

  def system_prompt
    'You are a helpful assistant that responds to user with next number in sequence.'
  end


  # Callbacks
  prompt text: -> { 'One' }, success: lambda { |_response|
    puts '===' * 60
    puts 'I can count!'
    puts '===' * 60
  }

  # Overriding system prompt
  prompt system: -> { 'Always say Hi! in front of sentence' }, text: -> { 'Three' }

  # Prompt with conditions
  prompt text: -> { '5' }, if: -> { current_prompt[:text].call == '5' }

  # Prompt with custom parameters
  prompt text: -> { 'Ten' }, params: { temperature: 0.7, max_tokens: 1000 }

  prompt text: -> { @until_breakpoint.to_s },
         until: -> { @until_breakpoint == MAX_SEQUENCE_LOOP },
         success: -> { @until_breakpoint += 1 }
end
