# Ruby AI Agent with RAIX

This project demonstrates how to create AI agents in Ruby using the RAIX (Ruby AI eXtensions) library. It's a port of my simple [Python's smolagents template](https://huggingface.co/spaces/dsawa/smolagents-agent-template), showcasing how to build AI assistants in Ruby.

## Features

- **Multi-tool AI Agent**: Access to web search, webpage content extraction, string manipulation, and time zone information
- **RAIX Integration**: Uses Ruby AI eXtensions for seamless LLM integration
- **Modular Tool System**: Individual tool classes that can be used independently
- **Prompt Templates**: Support for YAML-based prompt configuration
- **Interactive Mode**: Command-line interface for real-time interaction
- **Comprehensive Logging**: Detailed logging with configurable verbosity levels

## Available Tools

1. **Palindrome Check**: Checks if a string reads the same forwards and backwards
2. **String Reversal**: Reverses any given string
3. **Timezone Information**: Gets current time in any specified timezone
4. **Web Search**: Performs DuckDuckGo searches and returns formatted results
5. **Webpage Visitor**: Extracts and converts webpage content to readable markdown

## Installation

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd raix-demo
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Environment Setup**:
   Create a `.env` file with your API keys (you can copy from `.env.example`):
   ```bash
   OR_ACCESS_TOKEN=your_openrouter_token
   OAI_ACCESS_TOKEN=your_openai_token
   ```

## Usage

### Basic Agent Demo

Run the basic demo to see the agent in action:

```bash
ruby demo.rb
```

### Running Examples

The project includes several standalone examples:

1. **Basic Agent Demo**: `ruby demo.rb`
2. **Basic Chat Completion**: See `raix_demo/basic_example.rb`
3. **Prompt Declarations**: See `raix_demo/prompt_declarations_example.rb`
4. **Structured Responses**: See `raix_demo/structured_response_example.rb`

### Interactive Mode

Start an interactive session:

```bash
ruby demo.rb --interactive
```

### Using the Agent Programmatically

#### Agent

```ruby
require_relative 'config/application'
require_relative 'raix_demo/agent'

# Create and use the agent
agent = Agent.build
response = agent.run("What time is it in Tokyo?")
puts response
```

#### RAIX specific Examples

The project includes several example implementations:

```ruby
require_relative 'config/application'
require_relative 'raix_demo/basic_example'

# Basic chat completion
basic = BasicExample.new
```

```ruby
require_relative 'raix_demo/prompt_declarations_example'

# Prompt chain execution
prompt_example = PromptDeclarationsExample.new
```

```ruby
require_relative 'raix_demo/structured_response_example'

# Structured responses
structured = StructuredResponseExample.new
result = structured.analyze_person("John Doe")
```

### Tool Classes

Individual tool implementations in `raix_demo/tools/`:

- `VisitWebpageTool`: Web content extraction and markdown conversion
- `WebSearchTool`: DuckDuckGo search integration

## Configuration

### RAIX Configuration

The agent uses RAIX's configuration system. Set up in `config/initializers/raix.rb`:

```ruby
Raix.configure do |config|
  config.openrouter_client = OpenRouter::Client.new(access_token: ENV['OR_ACCESS_TOKEN'])
  config.openai_client = OpenAI::Client.new(access_token: ENV['OAI_ACCESS_TOKEN'])
  config.model = "openai/gpt-4o"  # or your preferred model
end
```

### Custom Prompts

Modify `prompts.yaml` to customize agent behavior:

```yaml
system_prompt: |
  Your custom system instructions here...
```

## Examples

### Web Research

```ruby
agent = Agent.build
response = agent.run("Search for information about Ruby 3.3 features and visit the official Ruby website to get details")
```

### Structured Responses

```ruby
require_relative 'raix_demo/structured_response_example'

example = StructuredResponseExample.new
result = example.analyze_person("Albert Einstein")
puts result
```

### Prompt Declarations

```ruby
require_relative 'raix_demo/prompt_declarations_example'

example = PromptDeclarationsExample.new
example.chat_completion(openai: "gpt-4o")
```

### Text Analysis

```ruby
agent = Agent.build
response = agent.run("Check if 'A man a plan a canal Panama' is a palindrome, then reverse it")
```

### Time Information

```ruby
agent = Agent.build
response = agent.run("What time is it currently in New York, London, and Tokyo?")
```

### Code Style

```bash
bundle exec rubocop
```

## Comparison with Python Version

As mentioned, this Ruby implementation mirrors the functionality of the Python smolagents template. Below is a quick reference for equivalent features:

| Feature          | Python (smolagents)    | Ruby (RAIX)                                      |
| ---------------- | ---------------------- | ------------------------------------------------ |
| Tool Definition  | `@tool` decorator      | `function` DSL method                            |
| Agent Creation   | `CodeAgent` class      | Include `ChatCompletion` + `FunctionDispatch`    |
| Prompt Templates | YAML + PromptTemplates | YAML + PromptDeclarations                        |
| Tool Execution   | Automatic dispatch     | Automatic dispatch with `dispatch_tool_function` |
| Streaming        | Built-in               | Available via RAIX streaming                     |
| Model Support    | HuggingFace + OpenAI   | OpenRouter + OpenAI                              |

## Dependencies

- **raix**: Ruby AI eXtensions for LLM integration
- **faraday**: HTTP client for web requests
- **nokogiri**: HTML parsing for webpage content
- **reverse_markdown**: HTML to Markdown conversion
- **tzinfo**: Timezone information handling

## Troubleshooting

### Common Issues

1. **Missing API Keys**: Ensure `.env` file contains valid API tokens
2. **Network Timeouts**: Check internet connection for web search and page visits
3. **Timezone Errors**: Verify timezone names (use TZInfo format like 'America/New_York')
4. **Tool Execution Limits**: Adjust `max_steps` parameter if agent stops prematurely

### Debugging

Enable detailed logging:

```ruby
agent = Agent.build(verbosity_level: 2)
```

Check RAIX configuration:

```ruby
puts Raix.configuration.inspect
```

## License

MIT License
