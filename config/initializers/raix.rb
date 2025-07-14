faraday_retry_options = {
  max: 3,
  interval: 0.5,
  interval_randomness: 0.5,
  backoff_factor: 2,
  retry_statuses: [429, 500, 502, 503, 504]
}.freeze

OpenRouter.configure do |config|
  config.faraday do |f|
    f.request :retry, faraday_retry_options
    f.response :logger, Logger.new($stdout), { headers: false, bodies: true, errors: true } do |logger|
      logger.filter(/(Bearer) (\S+)/, '\1 [REDACTED]')
    end
  end
end

Raix.configure do |config|
  # Set the OpenRouter model to use
  # config.model = 'mistralai/mistral-small-3.2-24b-instruct:free'
  config.model = 'google/gemini-2.0-flash-exp:free'

  config.openrouter_client = OpenRouter::Client.new(
    access_token: ENV.fetch('OPENROUTER_API_KEY')
  )

  config.openai_client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY', nil)) do |f|
    f.request :retry, faraday_retry_options
    f.response :logger, Logger.new($stdout), { headers: false, bodies: true, errors: true } do |logger|
      logger.filter(/(Bearer) (\S+)/, '\1 [REDACTED]')
    end
  end
end
