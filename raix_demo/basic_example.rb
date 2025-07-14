# frozen_string_literal: true

class BasicExample
  include Raix::ChatCompletion

  def initialize(model: Raix.configuration.model)
    @model = model
  end
end
