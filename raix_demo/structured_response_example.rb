# frozen_string_literal: true

class StructuredResponseExample
  include Raix::ChatCompletion

  def analyze_person(name)
    format = Raix::ResponseFormat.new('PersonAnalysis', {
                                        full_name: { type: 'string' },
                                        age_estimate: { type: 'integer' },
                                        personality_traits: ['string']
                                      })

    transcript << {
      user: "Analyze the person named #{name}"
    }

    chat_completion(
      params: { response_format: format }, openai: 'gpt-4o'
    )
  end
end
